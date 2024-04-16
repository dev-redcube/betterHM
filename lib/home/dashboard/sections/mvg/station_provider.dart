import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
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
  LiveLocationState _state = Prefs.lastMvgStation.value.isEmpty
      ? LiveLocationState.searching
      : LiveLocationState.off;

  LiveLocationState get state => _state;

  set state(LiveLocationState state) {
    _state = state;
    notifyListeners();
  }

  @override
  bool get hasListeners => super.hasListeners;
}
