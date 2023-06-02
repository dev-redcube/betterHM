import 'package:better_hm/extensions/extensions_date_time.dart';

class DateTuple {
  final DateTime start;
  final DateTime? end;

  DateTuple(this.start, this.end);

  bool get isSingleDay => end == null;

  bool isAroundToday() {
    final now = today();
    return start.isBefore(now) && end != null && end!.isAfter(now);
  }

  factory DateTuple.fromJson(Map<String, dynamic> json) => DateTuple(
        DateTime.parse(json["start"]),
        json["end"] == null ? null : DateTime.parse(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start.toIso8601String(),
        "end": end?.toIso8601String(),
      };
}
