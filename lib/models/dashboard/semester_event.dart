import 'package:better_hm/models/dashboard/event.dart';

class SemesterEvent extends Event {
  SemesterEvent({
    required super.title,
    required super.start,
    super.end,
  });

  factory SemesterEvent.fromJson(Map<String, dynamic> json) => SemesterEvent(
        title: json["title"] as String,
        start: DateTime.parse(json["start"] as String),
        end: json["end"] == null ? null : DateTime.parse(json["end"] as String),
      );

  @override
  Map<String, dynamic> toJson() => {
        "title": title,
        "start": start.toIso8601String(),
        "end": end?.toIso8601String(),
      };
}
