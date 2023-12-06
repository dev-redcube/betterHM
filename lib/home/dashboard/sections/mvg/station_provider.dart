import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/foundation.dart';

class StationProvider with ChangeNotifier {
  Station? _station = Prefs.lastMvgStation.value.isEmpty
      ? null
      : StationService.getFromId(Prefs.lastMvgStation.value);

  Station? get station => _station;

  set station(Station? station) {
    _station = station;
    notifyListeners();
  }
}

class SearchingStateProvider with ChangeNotifier {
  StationLocationState _state = Prefs.lastMvgStation.value.isEmpty
      ? StationLocationState.searching
      : StationLocationState.manual;

  StationLocationState get state => _state;

  set state(StationLocationState state) {
    _state = state;
    notifyListeners();
  }

  @override
  bool get hasListeners => super.hasListeners;
}

enum StationLocationState {
  manual,
  searching,
  found,
  error,
}
