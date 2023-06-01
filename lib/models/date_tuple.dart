class DateTuple {
  final DateTime start;
  final DateTime? end;

  DateTuple(this.start, this.end);

  factory DateTuple.fromJson(Map<String, dynamic> json) => DateTuple(
        DateTime.parse(json["start"]),
        json["end"] == null ? null : DateTime.parse(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start.toIso8601String(),
        "end": end?.toIso8601String(),
      };
}
