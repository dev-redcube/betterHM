import 'package:better_hm/home/dashboard/cards/mvg/station.dart';

final stationIds = <Station>[
  Station(id: "de:09162:12", name: "Hochschule München"),
  Station(id: "de:09162:1666", name: "Avenariusplatz"),
  Station(id: "de:09162:53", name: "Ottostraße"),
  Station(id: "de:09162:16", name: "Lenbachplatz"),
];

abstract class StationService {
  static Station? getFromId(String id) =>
      stationIds.where((element) => element.id == id).firstOrNull;
}
