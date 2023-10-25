import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/foundation.dart';

class StationProvider with ChangeNotifier {
  Station _station = StationService.getFromId(Prefs.selectedMvgStation.value)!;

  Station get station => _station;

  set station(Station station) {
    _station = station;
    notifyListeners();
  }
}
