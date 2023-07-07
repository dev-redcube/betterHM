import 'package:better_hm/home/dashboard/cards/mvg/line.dart';
import 'package:better_hm/home/dashboard/cards/mvg/station.dart';

final stationIds = <Station>[
  Station(id: "de:09162:12", name: "Hochschule München"),
];

final lineIds = <String, List<Line>>{
  "de:09162:12": [
    Line(
      id: "swm:02020:G:H:013",
      number: "20",
      direction: "Stachus",
      type: LineType.tram,
    ),
    Line(
      id: "swm:02020:G:R:013",
      number: "20",
      direction: "Moosach",
      type: LineType.tram,
    ),
    Line(
      id: "swm:02021:G:H:013",
      number: "21",
      direction: "St. Veitstraße",
      type: LineType.tram,
    ),
    Line(
      id: "swm:02021:G:R:013",
      number: "21",
      direction: "Westfriedhof",
      type: LineType.tram,
    ),
    Line(
      id: "swm:02029:G:R:013",
      number: "29",
      direction: "Willibaldplatz",
      type: LineType.tram,
    ),
    Line(
      id: "swm:02N20:G:H:013",
      number: "N20",
      direction: "Stachus",
      type: LineType.bus,
    ),
    Line(
      id: "swm:02N20:G:R:013",
      number: "N20",
      direction: "Moosach",
      type: LineType.bus,
    ),
    Line(
      id: "swm:03153:G:H:013",
      number: "153",
      direction: "Universität",
      type: LineType.bus,
    ),
    Line(
      id: "swm:03153:G:R:013",
      number: "153",
      direction: "Trappentreustraße",
      type: LineType.bus,
    ),
  ],
};

class StationService {
  static Station? getFromId(String id) =>
      stationIds.where((element) => element.id == id).firstOrNull;
}

class LineService {
  static List<Line>? getLinesFromStationId(String stationId) {
    return lineIds[stationId];
  }

  static Line? getFromId(String id) => lineIds.values
      .expand((element) => element)
      .where((element) => element.id == id)
      .firstOrNull;
}
