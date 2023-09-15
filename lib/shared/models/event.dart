import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Events {
  @JsonKey(name: "data")
  final List<Event> events;

  Events({required this.events});

  factory Events.fromJson(Map<String, dynamic> json) => _$EventsFromJson(json);

  Map<String, dynamic> toJson() => _$EventsToJson(this);
}

@JsonSerializable()
class Event {
  final String title;
  final String? description;
  final DateTime start;
  final DateTime? end;

  // final Location? location;

  Event({
    required this.title,
    required this.start,
    this.description,
    this.end,
    // this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
