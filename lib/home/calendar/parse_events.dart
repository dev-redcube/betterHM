import 'dart:io';

import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:icalendar/icalendar.dart';
import 'package:kalender/kalender.dart';
import 'package:logging/logging.dart';
import 'package:rrule/rrule.dart' as rrule;

Future<List<CalendarEvent<EventComponent>>> parseAllEvents() async {
  final iCalService = ICalService();
  final activeCalendars = await iCalService.getActiveCalendars();
  final path = await ICalService.getPath();

  final List<CalendarEvent<EventComponent>> events = [];

  for (final calendar in activeCalendars) {
    final file = File("${path.path}/${calendar.id}.ics");
    // TODO fetch
    if (!await file.exists()) continue;

    events.addAll(await parseICal(file, calendar));
  }

  return events;
}

Future<Iterable<CalendarEvent<EventComponent>>> parseEvents(
  Calendar calendar,
) async {
  final path = await ICalService.getPath();
  final file = File("${path.path}/${calendar.id}.ics");
  if (!await file.exists()) return Future.value([]);

  return parseICal(file, calendar);
}

Future<Iterable<Event>> parseICal(
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

  final List<CalendarEvent<EventComponent>> events = [];

  // VCALENDAR
  for (final calendar in ical) {
    // VEVENT
    for (final component in calendar.components) {
      if (component is EventComponent) {
        // start and either end or duration must be specified
        if (component.dateTimeStart == null) continue;
        if (component.end == null && component.duration == null) continue;

        final event = CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: component.dateTimeStart!.value.value,
            end: component.end?.value.value ??
                component.dateTimeStart!.value.value
                    .add(component.duration!.value.value),
          ),
          eventData: component,
          modifiable: false,
        );
        events.add(event);
      }
    }
  }
  stopwatch.stop();
  Logger("IcalParser").info(
    "$calendar parsed in ${stopwatch.elapsed.inSeconds} seconds",
  );
  return splitEvents(events);
}

List<Event> splitEvents(List<Event> events) {
  final List<Event> splitEvents = [];
  for (final event in events) {
    // add original event
    splitEvents.add(event);

    final data = event.eventData!;

    // RecurrenceDateTimes, "skip" if none
    if (data.recurrenceDateTimes != null) {
      splitEvents.addAll(_splitRecurrenceDates(event));
    }

    // RRULE
    if (data.recurrenceRules != null) {
      splitEvents.addAll(splitRRule(event));
    }
  }
  return splitEvents;
}

List<Event> _splitRecurrenceDates(Event event) {
  final List<Event> splitEvents = [];
  for (final time in event.eventData!.recurrenceDateTimes!) {
    for (final t in time.value.values) {
      final start = t.value.copyWith(
        hour: event.dateTimeRange.start.hour,
        minute: event.dateTimeRange.start.minute,
      );
      splitEvents.add(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: start,
            end: start.add(event.duration),
          ),
          eventData: event.eventData,
          modifiable: false,
        ),
      );
    }
  }
  return splitEvents;
}

List<Event> splitRRule(Event event) {
  final List<Event> splitEvents = [];
  final data = event.eventData!;
  for (final rule in data.recurrenceRules!) {
    final recur = rrule.RecurrenceRule.fromString(rule.toString());
    final instances = recur.getInstances(
      start: DateTime.now().add(const Duration(days: 365)),
    );

    // year before and after today
    final ranged = instances.takeWhile(
      (value) => value.year.compareTo(DateTime.now().year).abs() < 2,
    );

    for (final instance in ranged) {
      splitEvents.add(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: instance,
            end: instance.add(event.duration),
          ),
          eventData: event.eventData,
          modifiable: false,
        ),
      );
    }
  }

  return splitEvents;
}
