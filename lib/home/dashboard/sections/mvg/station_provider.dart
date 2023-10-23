import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:flutter/foundation.dart';

class StationProvider with ChangeNotifier {
  Station _station = stations.first;

  Station get station => _station;

  set station(Station station) {
    _station = station;
    notifyListeners();
  }
}
