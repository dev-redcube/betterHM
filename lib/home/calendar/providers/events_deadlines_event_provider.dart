import 'package:better_hm/shared/models/event_data.dart';
import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:kalender/kalender.dart';
import 'package:logging/logging.dart';

List<CalendarEvent<EventData>> _parseIcal(String body) {
  Logger("PARSE_ICAL_REMOVE")
      .fine("Parsing ical for Deadlines and Appointments");
  final ical = ICalendar.fromString(body);

  final mapped = ical.data.map((e) {
    final start = e["dtstart"] as IcsDateTime;
    final end = e["dtend"] as IcsDateTime?;

    final dtstart = DateTime.parse(start.dt);
    final dtend = end == null ? dtstart : DateTime.parse(end.dt);

    final range = DateTimeRange(start: dtstart, end: dtend);

    final event = CalendarEvent(
      dateTimeRange: range,
      eventData: EventData(title: e["summary"]),
    );

    return event;
  }).toList();

  return mapped;
}
