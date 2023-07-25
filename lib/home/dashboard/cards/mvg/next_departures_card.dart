import 'package:better_hm/home/dashboard/card_service.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/cards/mvg/config_screen.dart';
import 'package:better_hm/home/dashboard/cards/mvg/service/mvg_service.dart';
import 'package:better_hm/home/dashboard/cards/mvg/transport_type.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/material.dart';

import 'departure.dart';
import 'next_departures.dart';
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
    return MvgService().getDepartures(
      stationId: _config.station.id,
      transportTypes: _config.transportTypes,
      offset: Duration(seconds: _config.offset * 60),
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
  List<TransportType> transportTypes;
  int offset;

  NextDeparturesConfig({
    required this.station,
    required this.transportTypes,
    required this.offset,
  });

  void apply({
    final Station? station,
    final List<TransportType>? transportTypes,
    final int? offset,
  }) {
    this.station = station ?? this.station;
    this.transportTypes = transportTypes ?? this.transportTypes;
    this.offset = offset ?? this.offset;
  }

  Map<String, dynamic> toJson() => {
        "station": station.id,
        "transportTypes": transportTypes.map((e) => e.name).toList(),
        "offset": offset,
      };

  factory NextDeparturesConfig.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<TransportType> transportTypes = defaultConfig.transportTypes;
      if (json["transportTypes"] != null) {
        Iterable<TransportType> transportTypes =
            (json["transportTypes"] as List<dynamic>)
                .map((e) => TransportType.fromString(e));
        if (transportTypes.isEmpty) {
          transportTypes = defaultConfig.transportTypes;
        }
      }

      return NextDeparturesConfig(
        station:
            StationService.getFromId(json["station"]) ?? defaultConfig.station,
        transportTypes: transportTypes.toList(),
        offset: json["offset"],
      );
    }
    return defaultConfig;
  }

  static get defaultConfig => NextDeparturesConfig(
        station: StationService.getFromId("de:09162:12")!,
        transportTypes: TransportType.values,
        offset: 1,
      );
}
