import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_event_save.dart';
import 'package:better_hm/main.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar/icalendar.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class CalendarUpdateService {
  static Future<bool> updateAllCalendars() async {
    final isar = Isar.getInstance()!;
    final calendars =
        await isar.calendars.filter().isActiveEqualTo(true).findAll();

    bool hasError = false;

    for (final calendar in calendars) {
      try {
        await updateCalendar(calendar);
      } catch (e) {
        // Other calendars are still tried
        hasError = true;
      }
    }

    return hasError;
  }

  static Future<void> updateCalendar(
    Calendar calendar,
  ) async {
    return compute((_) => _updateCalendar, calendar);
  }

  static Future<void> _updateCalendar(
    Calendar calendar,
  ) async {
    final isar = await loadDb();
    final log = Logger("UpdateCalendar");

    late File file;

    try {
      file = await _downloadCalendar(calendar);
    } catch (e) {
      log.warning("Failed to download calendar ${calendar.name}", e);
      await isar.writeTxn(() async {
        calendar.numOfFails++;
        await isar.calendars.put(calendar);
      });
      rethrow;
    }

    List<CalendarEventSave> events = [];

    // Can throw,
    try {
      events = await _parseCalendar(calendar, file, log);
    } catch (e) {
      await file.delete();
      rethrow;
    }

    await isar.writeTxn(() async {
      await isar.calendarEventSaves.putAll(events);
      calendar.numOfFails = 0;
      calendar.lastUpdate = DateTime.now();
      await isar.calendars.put(calendar);
    });
    await file.delete();
  }

  static Future<File> _downloadCalendar(Calendar calendar) async {
    final directory = await getTemporaryDirectory();
    if (!await directory.exists()) await directory.create();
    final file = File("${directory.path}/${calendar.id}.ics");

    try {
      final response = await http.Client().get(Uri.parse(calendar.url));

      await file.writeAsBytes(response.bodyBytes);
    } catch (e) {
      await file.delete();
      rethrow;
    }

    return file;
  }

  static Future<List<CalendarEventSave>> _parseCalendar(
    Calendar calendar,
    File file,
    Logger log,
  ) async {
    final List<CalendarEventSave> events = [];

    final now = DateTime.now();
    final minusOneYear = now.subtract(const Duration(days: 365));
    final plusOneYear = now.add(const Duration(days: 365));

    final lines = await file.readAsLines();
    late final List<ICalendar> ical;
    try {
      ical = ICalendar.fromICalendarLines(lines);
    } catch (e, stacktrace) {
      Logger("Calendar").severe(
        "Failed to parse Calendar $calendar",
        e,
        stacktrace,
      );
      rethrow;
    }

    final stopwatch = Stopwatch()..start();

    // VCALENDAR
    for (final cal in ical) {
      // VEVENT
      for (final component in cal.components) {
        if (component is EventComponent) {
          // start and either end or duration must be specified
          if (component.dateTimeStart == null) continue;
          if (component.end == null && component.duration == null) continue;

          final splitUp = component.splitComponent();

          for (final split in splitUp) {
            final end = split.end?.value.value ??
                split.dateTimeStart!.value.value
                    .add(split.duration!.value.value);

            // only add events +- 1 Year
            if (end.isBefore(minusOneYear) ||
                split.dateTimeStart!.value.value.isAfter(plusOneYear)) continue;

            final event = CalendarEventSave(
              summary: split.summary?.value.value,
              description: split.description?.value.value,
              start: split.dateTimeStart!.value.value,
              end: end,
              location: split.location?.value.value,
            );

            events.add(event);
          }
        }
      }
    }
    stopwatch.stop();
    log.fine(
      "Parsed calendar ${calendar.name} in ${stopwatch.elapsed.inMilliseconds} ms",
    );

    return events;
  }
}
