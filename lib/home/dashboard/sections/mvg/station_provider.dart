import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'station_provider.g.dart';

class SelectedStationWrapper {
  final bool isAutomatic;
  final Station? station;

  SelectedStationWrapper({required this.isAutomatic, this.station});
}

@riverpod
class SelectedStation extends _$SelectedStation {
  @override
  Future<SelectedStationWrapper> build() async {
    final prefs = await SharedPreferences.getInstance();

    late final String? stationId;
    // Empty String means automatic, no key => use default
    if (!prefs.containsKey("selected-station")) {
      stationId = stations.first.id;
    } else {
      stationId = prefs.getString("selected-station");
    }

    final station =
        stations.firstWhereOrNull((element) => element.id == stationId);

    final isAutomatic = station == null;

    if (isAutomatic) _setToNearest();

    return SelectedStationWrapper(isAutomatic: isAutomatic, station: station);
  }

  void set(SelectedStationWrapper wrapper) {
    _setState(wrapper);

    if (wrapper.isAutomatic && wrapper.station == null) _setToNearest();
  }

  _setState(SelectedStationWrapper wrapper) {
    state = AsyncValue.data(wrapper);
    _saveStation(wrapper);
  }

  _saveStation(SelectedStationWrapper wrapper) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "selected-station",
      wrapper.isAutomatic ? "" : wrapper.station?.id ?? "",
    );
  }

  _setToNearest() async {
    final position = await LocationService()
        .determinePosition(desiredAccuracy: LocationAccuracy.medium);

    final nearest = stations
        .map(
          (e) => (
            e,
            e.location.distanceTo(position.latitude, position.longitude),
          ),
        )
        .toList();

    nearest.sort((a, b) => a.$2.compareTo(b.$2));
    final nearestStation = nearest.first.$1;

    set(
      SelectedStationWrapper(isAutomatic: true, station: nearestStation),
    );
  }
}
