import 'dart:convert';
import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:better_hm/shared/models/event_data.dart';
import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:kalender/kalender.dart';

Future<List<CalendarEvent<EventData>>> parseAllEvents() async {
  final iCalService = ICalService();
  final activeCalendars = await iCalService.getActiveCalendars();
  final path = await ICalService.getPath();

  final List<CalendarEvent<EventData>> events = [];

  for (final calendar in activeCalendars) {
    final file = File("${path.path}/${calendar.id}.ics");
    // TODO fetch
    if (!await file.exists()) continue;

    events.addAll(await parseICal(file, calendar));
  }

  return events;
}

Future<Iterable<CalendarEvent<EventData>>> parseEvents(
  Calendar calendar,
) async {
  final path = await ICalService.getPath();
  final file = File("${path.path}/${calendar.id}.ics");
  if (!await file.exists()) return Future.value([]);

  return parseICal(file, calendar);
}

Future<Iterable<CalendarEvent<EventData>>> parseICal(
  File file,
  Calendar calendar,
) async {
  final body = utf8.decode(await file.readAsBytes());
  final ical = ICalendar.fromString(body);

  // TODO split repeated events into multiple
  final mapped = ical.data.map((e) {
    final start = e["dtstart"] as IcsDateTime;
    final end = e["dtend"] as IcsDateTime?;

    final dtstart = DateTime.parse(start.dt);
    final dtend = end == null ? dtstart : DateTime.parse(end.dt);

    final range = DateTimeRange(start: dtstart, end: dtend);

    final event = CalendarEvent(
      dateTimeRange: range,
      eventData: EventData(title: e["summary"], calendarId: calendar.id),
    );

    return event;
  });

  return mapped;
}
