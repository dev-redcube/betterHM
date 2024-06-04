import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_event_save.dart';
import 'package:flutter/foundation.dart';
import 'package:icalendar/icalendar.dart';
import 'package:logging/logging.dart';

class CalendarHelpers {
  static Future<Iterable<CalendarEventSave>> parseICal(
    File file,
    Calendar calendar,
  ) async {
    return compute((_) => _parseICal(file, calendar), null);
  }

  static Future<Iterable<CalendarEventSave>> _parseICal(
    File file,
    Calendar calendar,
  ) async {
    final lines = await file.readAsLines();

    final stopwatch = Stopwatch()..start();
    late final List<ICalendar> ical;
    try {
      ical = ICalendar.fromICalendarLines(lines);
    } catch (e, stacktrace) {
      Logger("Calendar").severe(
        "Failed to parse Calendar $calendar",
        e,
        stacktrace,
      );
      return Future.value([]);
    }

    final List<CalendarEventSave> events = [];

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
            final event = CalendarEventSave(
              summary: split.summary?.value.value,
              description: split.description?.value.value,
              start: split.dateTimeStart!.value.value,
              end: split.end?.value.value ??
                  split.dateTimeStart!.value.value
                      .add(split.duration!.value.value),
              location: split.location?.value.value,
            );

            events.add(event);
          }
        }
      }
    }

    stopwatch.stop();
    Logger("IcalParser").finest(
      "$calendar parsed in ${stopwatch.elapsed.inSeconds} seconds",
    );
    return events;
  }
}
