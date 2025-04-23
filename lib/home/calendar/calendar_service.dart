import 'dart:async';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_link.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';

class CalendarService {
  /// Fetches all available calendars from the backend
  /// If [filterAdded] is true, only calendars are not already present in the calendars database
  static Future<List<CalendarLink>> getAvailableCalendars({
    bool filterAdded = false,
  }) async {
    final mainApi = getIt<MainApi>();
    final endpoint = Uri(
      scheme: "https",
      host: "api.betterhm.app",
      path: "/v1/calendar",
    );
    final calendars = await mainApi.getNeverCache(
      endpoint,
      (p0) => CalendarLinksWrapper.fromJson(p0),
    );

    if (filterAdded) {
      final alreadyAddedIds =
          (await getIt<Isar>().calendars.where().findAll())
              .map((e) => e.externalId)
              .toSet();

      return calendars.data.links
          .whereNot((e) => alreadyAddedIds.contains(e.id))
          .toList();
    }

    return calendars.data.links;
  }

  Future<void> syncCalendar(Calendar calendar) async {}

  /// Returns all calendars that are currently available in the database
  Future<List<Calendar>> getAllCalendars() => Future.value([]);

  /// Returns all calendars that are currently available in the database and marked as active
  Future<List<Calendar>> getActiveCalendars() => Future.value([]);

  /// Fetches the ical of a single calendar
  /// Throws an exception if the ical cannot be fetched
  /// Requires a [Calendar] object which can be obtained from [getActiveCalendars] or [getAllCalendars]
  Future<void> fetchCalendar(Calendar calendar) => Future.value();
}
