import 'package:better_hm/home/calendar/models/calendar_event.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/networking/apis/betterhm/betterhm_api.dart';
import 'package:better_hm/shared/networking/apis/betterhm/betterhm_api_service.dart';
import 'package:better_hm/shared/networking/main_api.dart';

class CalendarService {
  static Future<(DateTime?, List<CalendarEvent>)> fetchEvents(
      bool forcedRefresh) async {
    MainApi mainApi = getIt<MainApi>();

    final response = await mainApi.makeRequest<CalendarEventsData, BetterHmApi>(
      BetterHmApi(BetterHmServiceCalendar()),
      CalendarEventsData.fromJson,
      forcedRefresh,
    );

    return (response.saved, response.data.events);
  }
}
