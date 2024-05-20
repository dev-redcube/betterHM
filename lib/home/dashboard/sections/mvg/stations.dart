import 'package:better_hm/shared/models/location.dart';
import 'package:flutter/material.dart';

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
