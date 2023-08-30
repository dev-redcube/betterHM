import 'package:json_annotation/json_annotation.dart';

part 'calendar_event.g.dart';

@JsonSerializable()
class CalendarEventsData {
  @JsonKey(name: "data")
  final List<CalendarEvent> events;

  CalendarEventsData({required this.events});

  factory CalendarEventsData.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventsDataToJson(this);
}

@JsonSerializable()
class CalendarEvent {
  final String title;
  final String? description;
  final DateTime start;
  final DateTime? end;

  CalendarEvent({
    required this.title,
    this.description,
    required this.start,
    this.end,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}
