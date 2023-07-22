import 'package:better_hm/home/dashboard/card_service.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/cards/mvg/config_screen.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/material.dart';

import 'departure.dart';
import 'line.dart';
import 'next_departures.dart';
import 'service/api_mvg.dart';
import 'service/data.dart';
import 'station.dart';

class NextDeparturesCard extends ICard<List<Departure>> {
  late NextDeparturesConfig _config;

  @override
  Map<String, dynamic> get config => _config.toJson();

  @override
  set config(Map<String, dynamic>? config) {
    _config = NextDeparturesConfig.fromJson(config);
  }

  @override
  Future<List<Departure>> future() {
    return ApiMvg().getDepartures(
      stationId: _config.station.id,
      lineIds: _config.lines.map((e) => e.id),
      leadTime: Duration(seconds: _config.leadTime * 60),
    );
  }

  @override
  Widget render(data) => NextDepartures(departures: data);

  @override
  Widget? renderConfig(int cardIndex) => NextDeparturesConfigScreen(
        config: _config,
        onChanged: (config) {
          _config = config;
          CardService()
              .replaceCardAt(cardIndex, Tuple(CardType.nextDepartures, this));
        },
      );
}

class NextDeparturesConfig {
  Station station;
  List<Line> lines;
  int leadTime;

  NextDeparturesConfig({
    required this.station,
    required this.lines,
    required this.leadTime,
  });

  void apply(NextDeparturesConfig config) {
    station = config.station;
    lines = config.lines;
    leadTime = config.leadTime;
  }

  Map<String, dynamic> toJson() => {
        "station": station.id,
        "lines": lines.map((e) => e.id).toList(),
        "leadTime": leadTime,
      };

  factory NextDeparturesConfig.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      Iterable<Line> lines = (json["lines"] as List<dynamic>)
          .map((e) => LineService.getFromId(e))
          .where((element) => element != null)
          .cast<Line>();
      if (lines.isEmpty) {
        lines = defaultConfig.lines;
      }
      return NextDeparturesConfig(
        station:
            StationService.getFromId(json["station"]) ?? defaultConfig.station,
        lines: lines.toList(),
        leadTime: json["leadTime"],
      );
    }
    return defaultConfig;
  }

  static get defaultConfig => NextDeparturesConfig(
        station: StationService.getFromId("de:09162:12")!,
        lines: lineIds["de:09162:12"]!,
        leadTime: 1,
      );
}
