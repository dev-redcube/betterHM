import 'package:better_hm/shared/extensions/extensions_date_time.dart';

class DateTuple {
  final DateTime start;
  final DateTime? end;

  DateTuple(this.start, this.end)
      : assert(
            end?.isAfter(start) ?? true, "End date must be after start date");

  bool get isSingleDay => end == null;

  bool get isFinished => (end ?? start).isBefore(today());

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
