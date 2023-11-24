import 'package:better_hm/shared/models/event_data.dart';
import 'package:kalender/kalender.dart';

abstract class EventProvider {
  Future<List<CalendarEvent<EventData>>> getEvents();
}
