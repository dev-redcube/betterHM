import 'package:flutter/painting.dart';
import 'package:icalendar/icalendar.dart';

class EventData {
  final String calendarId;
  final Color? color;
  final EventComponent component;

  EventData({required this.calendarId, this.color, required this.component});

  @override
  String toString() =>
      "EventData(calendarId: $calendarId, color: $color, component: $component)";
}
