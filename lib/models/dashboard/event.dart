import 'package:better_hm/models/location.dart';
import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id id = Isar.autoIncrement;

  final String title;
  final String? description;
  final DateTime start;
  final DateTime? end;

  @ignore
  final Location? location;

  @Index()
  String? context;

  Event({
    required this.title,
    required this.start,
    this.description,
    this.end,
    this.location,
    this.context,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json["title"] as String,
        description: json["description"] as String?,
        start: DateTime.parse(json["start"] as String),
        end: json["end"] == null ? null : DateTime.parse(json["end"] as String),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        context: json["context"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "start": start.toIso8601String(),
        "end": end?.toIso8601String(),
        "location": location?.toJson(),
        "context": context,
      };
}
