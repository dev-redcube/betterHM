import 'package:better_hm/home/dashboard/cards/mvg/station.dart';

final stationIds = <Station>[
  Station(id: "de:09162:12", name: "Hochschule München"),
];

abstract class StationService {
  static Station? getFromId(String id) =>
      stationIds.where((element) => element.id == id).firstOrNull;
}
