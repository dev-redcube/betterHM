import 'package:better_hm/home/dashboard/mvg/line.dart';
import 'package:better_hm/home/dashboard/mvg/station.dart';

class Departure {
  final Line line;
  final String direction;
  final Station station;
  final DateTime departurePlanned;
  final DateTime? departureLive;
  final bool inTime;
  final String? error;

  Departure({
    required this.line,
    required this.direction,
    required this.station,
    required this.departurePlanned,
    this.departureLive,
    required this.inTime,
    this.error,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json["departureDate"]);
    final planned = json["departurePlanned"].split(":");
    final departurePlanned = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(planned[0]),
      int.parse(planned[1]),
    );
    final pattern = RegExp(r'\d?\d:\d\d');
    DateTime? departureLive;
    String? error;
    if (pattern.hasMatch(json["departureLive"])) {
      final live = json["departureLive"].split(":");
      departureLive = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(live[0]),
        int.parse(live[1]),
      );
    } else {
      error = json["departurePlanned"];
    }

    return Departure(
      line: Line.fromJson(json["line"]),
      direction: json["direction"],
      station: Station.fromJson(json["station"]),
      departurePlanned: departurePlanned,
      departureLive: departureLive,
      inTime: json["inTime"],
      error: error,
    );
  }
}
