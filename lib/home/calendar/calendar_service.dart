import 'dart:async';

import 'package:kalender/kalender.dart';
import 'package:redcube_campus/home/calendar/models/calendar.dart';
import 'package:redcube_campus/home/calendar/models/calendar_link.dart';
import 'package:redcube_campus/main.dart';
import 'package:redcube_campus/shared/models/event_data.dart';
import 'package:redcube_campus/shared/networking/main_api.dart';

typedef CustomCalendarEvent = CalendarEvent<EventData>;

class CalendarService {
  /// Fetches all available calendars from the backend
  Future<List<CalendarLink>> getAvailableCalendars() async {
    final mainApi = getIt<MainApi>();
    final endpoint = Uri(
      scheme: "https",
      host: "api.redcube.dev",
      path: "/v1/calendar",
    );
    final calendars = await mainApi.getNeverCache(
      endpoint,
      (p0) => CalendarLinksWrapper.fromJson(p0),
    );
    return calendars.data.links;
  }

  /// Returns all calendars that are currently available in the database
  Future<List<Calendar>> getAllCalendars() => Future.value([]);

  /// Returns all calendars that are currently available in the database and marked as active
  Future<List<Calendar>> getActiveCalendars() => Future.value([]);

  /// Fetches the ical of a single calendar
  /// Throws an exception if the ical cannot be fetched
  /// Requires a [Calendar] object which can be obtained from [getActiveCalendars] or [getAllCalendars]
  Future<void> fetchCalendar(Calendar calendar) => Future.value();
}
