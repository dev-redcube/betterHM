import 'package:better_hm/home/dashboard/mvg/line.dart';
import 'package:better_hm/home/dashboard/mvg/station.dart';

class Departure {
  final Line line;
  final String direction;
  final Station station;
  final DateTime departurePlanned;
  final DateTime departureLive;
  final bool inTime;

  Departure({
    required this.line,
    required this.direction,
    required this.station,
    required this.departurePlanned,
    required this.departureLive,
    required this.inTime,
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
    final live = json["departureLive"].split(":");
    final departureLive = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(live[0]),
      int.parse(live[1]),
    );

    return Departure(
      line: Line.fromJson(json["line"]),
      direction: json["direction"],
      station: Station.fromJson(json["station"]),
      departurePlanned: departurePlanned,
      departureLive: departureLive,
      inTime: json["inTime"],
    );
  }
}
