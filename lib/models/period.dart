class Period {
  final DateTime start;
  final DateTime end;

  Period(this.start, this.end);

  factory Period.fromJson(Map<String, dynamic> json) => Period(
        DateTime.parse(json["start"]),
        DateTime.parse(json["start"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
      };
}
