import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/event_data.dart';
import 'package:better_hm/home/calendar/service/calendar_sync_service.dart';
import 'package:better_hm/shared/extensions/extensions_file.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar/icalendar.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rrule/rrule.dart' as rrule;

class CalendarSyncException implements Exception {
  String cause;

  CalendarSyncException(this.cause);
}

class CalendarSyncTask implements CalendarTask {
  final _logger = Logger("CalendarSyncTask");
  final Calendar calendar;

  CalendarSyncTask(this.calendar);

  @override
  Future<void> run() async {
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) await tempDir.create(recursive: true);

    final file = File("${tempDir.path}/calendar-${calendar.id}.ics");
    final uri = Uri.parse(calendar.url);
    final response = await http.Client().get(uri);

    if (200 != response.statusCode)
      throw CalendarSyncException(
        "Failed to download Calendar ${calendar.name}",
      );

    await file.writeAsBytes(response.bodyBytes);

    // Parsing
    final events = await getEvents(file);

    final isar = Isar.getInstance()!;
    await isar.writeTxn(() async {
      calendar.events.clear();
      calendar.events.addAll(events);

      await isar.calendars.put(calendar);
    });
  }

  @override
  Future<void> onError(Exception e) async {
    if (calendar.id == null) return;

    final isar = Isar.getInstance()!;

    // Increment error counter
    await isar.writeTxn(() async {
      final cal = await isar.calendars.get(calendar.id!);
      cal!.numOfFails++;
      await isar.calendars.put(cal);
    });
  }

  Future<List<EventData>> getEvents(File icalFile) async {
    final lines = await icalFile.readAsLines();
    final stopwatch = Stopwatch()..start();

    final List<ICalendar> ical;
    try {
      ical = ICalendar.fromICalendarLines(lines);
    } catch (e, stacktrace) {
      _logger.severe("Failed to parse ical file", e, stacktrace);
      throw CalendarSyncException(
        "Failed to parse ical file ${icalFile.filename}",
      );
    }

    final List<EventData> events = [];

    // VCALENDAR
    for (final cal in ical) {
      // VEVENT
      for (final component in cal.components) {
        if (component is EventComponent) {
          // start and either end or duration must be specified
          if (component.dateTimeStart == null) continue;
          if (component.end == null && component.duration == null) continue;

          events.addAll(_eventsFromComponent(component));
        }
      }
    }

    _logger.info(
      "Parsed ${events.length} events for ${calendar.name} in ${stopwatch.elapsed.inSeconds}s",
    );

    return events;
  }

  List<EventData> _eventsFromComponent(EventComponent component) {
    final List<EventData> split = [];

    // Event itself
    final event = EventData(
      title: component.summary!.value.value,
      start: component.dateTimeStart!.value.value,
      end:
          component.end?.value.value ??
          component.dateTimeStart!.value.value.add(
            component.duration!.value.value,
          ),
      description: component.description?.value.value,
      room: component.location?.value.value,
    );
    split.add(event);

    final duration = event.duration;

    // recurrence dates
    if (component.recurrenceDateTimes != null)
      for (final time in component.recurrenceDateTimes!) {
        for (final t in time.value.values) {
          final start = t.value.copyWith(
            hour: event.start.hour,
            minute: event.start.minute,
          );

          split.add(event.copyWith(start: start, end: start.add(duration)));
        }
      }

    // rrule
    if (component.recurrenceRules != null)
      for (final rule in component.recurrenceRules!) {
        final now = DateTime.now();
        final recur = rrule.RecurrenceRule.fromString(rule.toString());
        final instances = recur.getInstances(
          start: now.subtract(Duration(days: 30)).copyWith(isUtc: true),
        );

        // Filter two months
        final ranged = instances.takeWhile(
          (value) => value.difference(now).inDays < 60,
        );

        for (final instance in ranged) {
          split.add(
            event.copyWith(start: instance, end: instance.add(duration)),
          );
        }
      }

    return split;
  }
}
