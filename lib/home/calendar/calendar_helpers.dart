import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_event_save.dart';
import 'package:better_hm/home/calendar/parse_events.dart';
import 'package:flutter/foundation.dart';
import 'package:icalendar/icalendar.dart';
import 'package:logging/logging.dart';

class CalendarHelpers {
  static Future<Iterable<CalendarEventSave>> parseIcal(File file,
      Calendar calendar,) async {
    return compute((_) => _parseIcal(file, calendar), null);
  }

  static Future<Iterable<CalendarEventSave>> _parseIcal(File file,
      Calendar calendar) async {
    final lines = await file.readAsLines();

    final stopwatch = Stopwatch()
      ..start();
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

          final event = CalendarEventSave(
            summary: component.summary?.value.value,
            description: component.description?.value.value,
            start: component.dateTimeStart!.value.value,
            end: component.end?.value.value ??
                component.dateTimeStart!.value.value
                    .add(component.duration!.value.value),
            location: component.location?.value.value,
          );

          events.add(event);
        }
      }
    }

    stopwatch.stop();
    Logger("IcalParser").fine(
      "$calendar parsed in ${stopwatch.elapsed.inSeconds} seconds",
    );
    return splitEvents(events);
  }

  /// If an EventComponent has RecurrenceDateTimes or an RecurrenceRule,
  /// split it into multiple Components
  List<EventComponent> splitEvents(Iterable<EventComponent> components) {
    final List<EventComponent> splitEvents = [];
    for (var event in components) {
      // RecurrenceDateTimes, "skip" if none
      if (event.recurrenceDateTimes != null) {
        splitEvents.addAll(_splitRecurrenceDates(event));
      }

      // RRULE
      if (event.recurrenceRules != null) {
        splitEvents.addAll(_splitRRule(event));
      }

      // Add Event itself, TODO copyWith function in lib
      splitEvents.add(event);
    }
  }

  List<EventComponent> _splitRecurrenceDates(EventComponent component)
}
