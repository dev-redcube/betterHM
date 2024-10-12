import 'package:json_annotation/json_annotation.dart';

part 'departure.g.dart';

@JsonSerializable(createToJson: false)
class Departure {
  @JsonKey(fromJson: fromMillisecondsSinceEpoch)
  final DateTime plannedDepartureTime;
  final bool realtime;
  @JsonKey(defaultValue: 0)
  final int delayInMinutes;
  @JsonKey(fromJson: fromMillisecondsSinceEpoch)
  final DateTime realtimeDepartureTime;
  final String transportType;

  final String label;

  final String destination;

  @JsonKey(defaultValue: false)
  final bool cancelled;

  @JsonKey(defaultValue: false)
  final bool sev;

  final String? occupancy;

  final String stopPointGlobalId;

  Departure({
    required this.plannedDepartureTime,
    required this.realtime,
    required this.delayInMinutes,
    required this.realtimeDepartureTime,
    required this.transportType,
    required this.label,
    required this.destination,
    required this.cancelled,
    required this.sev,
    required this.occupancy,
    required this.stopPointGlobalId,
  });

  factory Departure.fromJson(Map<String, dynamic> json) =>
      _$DepartureFromJson(json);

  static DateTime fromMillisecondsSinceEpoch(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp);
}

@JsonSerializable(createToJson: false)
class Departures {
  @JsonKey(name: "data")
  final List<Departure> departures;

  Departures(this.departures);

  factory Departures.fromJson(Map<String, dynamic> json) =>
      _$DeparturesFromJson(json);
}
