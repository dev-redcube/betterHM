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

class CalendarSyncException implements Exception {
  String cause;

  CalendarSyncException(this.cause);
}

class CalendarSyncTask implements CalendarTask {
  final _logger = Logger("CalendarSyncTask");
  final Calendar calendar;

  const CalendarSyncTask(this.calendar);

  @override
  Future<void> run() async {
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) await tempDir.create(recursive: true);

    final file = File("${tempDir.path}/calendar-${calendar.id}.ics");
    final uri = Uri.parse(calendar.url);
    final response = await http.Client().get(uri);

    if (200 != response.statusCode)
      throw CalendarSyncException("Failed to download Calendar ${calendar.name}");

    await file.writeAsBytes(response.bodyBytes);

    // Parsing
    final events = getEvents(file);
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

  Future<EventData> getEvents(File icalFile) async {
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

          events.add(splitEvent(event));
        }
      }
    }

    _logger.info("Parsed ${events.length} events for ${calendar.name} in ${stopwatch.elapsed.inSeconds}s");
  }

  List<EventData> splitEvent(EventData event) {
    final List<EventData> split = [];
    split.add(event);
  }
}
