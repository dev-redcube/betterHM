import 'package:better_hm/home/dashboard/cards/mvg/line.dart';

enum Stations {
  lothstr;

  @override
  String toString() => name;

  static Stations fromString(String string) => values.byName(string);
}

const stationIds = {
  Stations.lothstr: "de:09162:12",
};

final lineIds = <Stations, List<Line>>{
  Stations.lothstr: [
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
