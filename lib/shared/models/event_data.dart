import 'package:icalendar/icalendar.dart';

class EventData {
  final String calendarId;
  final EventComponent component;

  EventData({required this.calendarId, required this.component});
}
