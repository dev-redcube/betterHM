import 'package:better_hm/shared/models/location.dart';

class Event {
  final String title;
  final String? description;
  final DateTime start;
  final DateTime? end;

  final Location? location;

  Event({
    required this.title,
    required this.start,
    this.description,
    this.end,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json["title"] as String,
        description: json["description"] as String?,
        start: DateTime.parse(json["start"] as String),
        end: json["end"] == null ? null : DateTime.parse(json["end"] as String),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "start": start.toIso8601String(),
        "end": end?.toIso8601String(),
        "location": location?.toJson(),
      };
}
