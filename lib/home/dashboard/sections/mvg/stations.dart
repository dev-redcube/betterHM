import 'package:better_hm/main.dart';
import 'package:better_hm/shared/models/location.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';

class Station {
  final String name;
  final String id;
  final String? campus;
  final IconData icon;
  final Location location;

  Station({
    required this.name,
    required this.id,
    required this.icon,
    required this.location,
    this.campus,
  });
}

abstract class StationService {
  static Station? getFromId(String id) =>
      stations.where((element) => element.id == id).firstOrNull;

  static Future<Station?> getNearestStation() async {
    final logger = Logger("MvgSection");

    final locationService = getIt<LocationService>();
    Position? position;
    try {
      position = await locationService.determinePosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e, stacktrace) {
      logger.warning("Failed to get location", e, stacktrace);
      return null;
    }

    final nearest = stations
        .map(
          (e) => (
            e,
            e.location.distanceTo(position!.latitude, position.longitude)
          ),
        )
        .toList();
    nearest.sort((a, b) => a.$2.compareTo(b.$2));

    final nearestStation = nearest.firstOrNull?.$1;

    if (nearestStation != null) {
      logger.info(
        "Nearest Station: ${nearestStation.name}. Location: lat. ${position.latitude} lon. ${position.longitude}. Accuracy: ${position.accuracy}",
      );
    } else {
      logger.warning(
        "Failed to get nearest Station. Location: lat. ${position.latitude} lon. ${position.longitude}. Accuracy: ${position.accuracy}",
      );
    }

    return nearestStation;
  }
}

final stations = <Station>[
  Station(
    id: "de:09162:12",
    name: "Hochschule Lothstr.",
    campus: "Innenstadt",
    icon: Icons.tram_rounded,
    location: Location(
      48.1542681140481,
      11.5538230200812,
    ),
  ),
  Station(
    id: "de:09162:1666",
    name: "Avenariusplatz",
    campus: "Pasing",
    icon: Icons.directions_bus_rounded,
    location: Location(
      48.1424272997168,
      11.45065957687,
    ),
  ),
  Station(
    id: "de:09162:1626",
    name: "Planegger Straße",
    campus: "Pasing",
    icon: Icons.directions_bus_rounded,
    location: Location(
      48.1401460243342,
      11.4569857252926,
    ),
  ),
  Station(
    id: "de:09162:53",
    name: "Ottostraße",
    icon: Icons.tram_rounded,
    location: Location(
      48.1423331560321,
      11.5677667325439,
    ),
  ),
  Station(
    id: "de:09162:16",
    name: "Lenbachplatz",
    icon: Icons.tram_rounded,
    location: Location(
      48.1408603049893,
      11.5683165557013,
    ),
  ),
];
