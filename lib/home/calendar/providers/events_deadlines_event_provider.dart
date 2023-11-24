import 'package:better_hm/home/calendar/event_provider.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/models/event_data.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:kalender/kalender.dart';
import 'package:logging/logging.dart';

class DeadlinesAppointmentsEventProvider extends EventProvider {
  final uri = Uri(
    scheme: "https",
    host: "betterhm.huber.cloud",
    path: "/events/ical",
  );

  final _logger = Logger(EventProvider.loggerTag);

  @override
  Future<List<CalendarEvent<EventData>>> getEvents() async {
    _logger.fine("Fetching Deadlines and Appointments");
    final mainApi = getIt<MainApi>();

    final response = await mainApi.getRawString(uri);
    return _parseIcal(response.data);
  }

  List<CalendarEvent<EventData>> _parseIcal(String body) {
    _logger.fine("Parsing ical for Deadlines and Appointments");
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
}
