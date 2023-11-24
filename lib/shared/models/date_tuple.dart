import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:json_annotation/json_annotation.dart';

part 'date_tuple.g.dart';

@JsonSerializable()
class DateTuple {
  final DateTime start;
  final DateTime? end;

  DateTuple(this.start, this.end)
      : assert(
          end?.isAfter(start) ?? true,
          "End date must be after start date",
        );

  bool get isSingleDay => end == null;

  bool get isFinished => (end ?? start).isBefore(today());

  bool isAroundToday() {
    final now = today();
    return start.isBefore(now) && end != null && end!.isAfter(now);
  }

  factory DateTuple.fromJson(Map<String, dynamic> json) =>
      _$DateTupleFromJson(json);

  Map<String, dynamic> toJson() => _$DateTupleToJson(this);
}
