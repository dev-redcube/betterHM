import 'package:better_hm/models/date_tuple.dart';

class SemesterEvent {
  final String title;
  final List<DateTuple> dates;

  SemesterEvent({
    required this.title,
    required this.dates,
  });

  factory SemesterEvent.fromJson(Map<String, dynamic> json) => SemesterEvent(
        title: json["title"] as String,
        dates: List<DateTuple>.from(
            json["dates"].map((x) => DateTuple.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "dates": dates.map((x) => x.toJson()).toList(),
      };
}
