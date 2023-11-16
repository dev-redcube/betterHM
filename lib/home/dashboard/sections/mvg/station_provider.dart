import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/foundation.dart';

class StationProvider with ChangeNotifier {
  StationState _state = StationState(
    StationService.getFromId(Prefs.lastMvgStation.value)!,
    Prefs.autoMvgStation.value
        ? StationLocationState.searching
        : StationLocationState.manual,
  );

  StationState get state => _state;

  set state(StationState state) {
    _state = state;
    notifyListeners();
  }
}

class StationState {
  final Station station;
  final StationLocationState locationState;

  StationState(this.station, this.locationState);
}

enum StationLocationState {
  manual,
  searching,
  found,
  error,
}
