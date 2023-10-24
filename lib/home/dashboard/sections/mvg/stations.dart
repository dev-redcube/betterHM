import 'package:flutter/material.dart';

class Station {
  final String name;
  final String id;
  final String? campus;
  final IconData icon;

  Station({
    required this.name,
    required this.id,
    required this.icon,
    this.campus,
  });
}

abstract class StationService {
  static Station? getFromId(String id) =>
      stations.where((element) => element.id == id).firstOrNull;
}

final stations = <Station>[
  Station(
    id: "de:09162:12",
    name: "Hochschule München Lothstr.",
    campus: "Innenstadt",
    icon: Icons.tram_rounded,
  ),
  Station(
    id: "de:09162:1666",
    name: "Avenariusplatz",
    campus: "Pasing",
    icon: Icons.directions_bus_rounded,
  ),
  Station(
    id: "de:09162:1626",
    name: "Planegger Straße",
    campus: "Pasing",
    icon: Icons.directions_bus_rounded,
  ),
  Station(
    id: "ID",
    name: "Ottostraße",
    icon: Icons.tram_rounded,
  ),
  Station(
    id: "ID",
    name: "Lenbachplatz",
    icon: Icons.tram_rounded,
  ),
];
