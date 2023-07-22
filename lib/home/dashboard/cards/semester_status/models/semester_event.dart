import 'package:better_hm/shared/models/date_tuple.dart';

class SemesterEvent {
  final String title;
  final List<DateTuple> dates;
  final String? tag;

  SemesterEvent({
    required this.title,
    required this.dates,
    this.tag,
  });

  factory SemesterEvent.fromJson(Map<String, dynamic> json) => SemesterEvent(
        title: json["title"] as String,
        dates: List<DateTuple>.from(
            json["dates"].map((x) => DateTuple.fromJson(x))),
        tag: json["tag"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "dates": dates.map((x) => x.toJson()).toList(),
        "tag": tag,
      };
}
