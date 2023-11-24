import 'package:better_hm/home/calendar/event_provider.dart';
import 'package:better_hm/shared/models/event_data.dart';
import 'package:kalender/kalender.dart';

class EventsDeadlinesEventProvider extends EventProvider {
  final uri = Uri(
    scheme: "https",
    host: "api.betterhm.app",
    path: "/events/",
  );

  @override
  Future<List<CalendarEvent<EventData>>> getEvents() async {
    throw UnimplementedError();
  }
}
