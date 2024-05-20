import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'selected_canteen_wrapper.g.dart';

class SelectedCanteenWrapper {
  final bool isAutomatic;
  final bool hasError;
  final Canteen? canteen;

  SelectedCanteenWrapper({
    required this.isAutomatic,
    this.hasError = false,
    this.canteen,
  });
}

@riverpod
class SelectedCanteen extends _$SelectedCanteen {
  @override
  Future<SelectedCanteenWrapper> build() async {
    final canteens = await ref.watch(canteensProvider.future);
    final prefs = await SharedPreferences.getInstance();

    late final String? canteenEnum;
    // Empty String means automatic, no key => use default
    if (!prefs.containsKey("selected-canteen"))
      canteenEnum = "MENSA_LOTHSTR";
    else
      canteenEnum = prefs.getString("selected-canteen");

    final Canteen? canteen = canteens.firstWhereOrNull(
      (element) => element.enumName == canteenEnum,
    );

    final isAutomatic = canteen == null;

    if (isAutomatic) _setToNearest();

    return SelectedCanteenWrapper(
      isAutomatic: canteen == null,
      canteen: canteen,
    );
  }

  void set(SelectedCanteenWrapper wrapper) {
    _setState(wrapper);

    if (wrapper.isAutomatic && wrapper.canteen == null && !wrapper.hasError)
      _setToNearest();
  }

  _setState(SelectedCanteenWrapper wrapper) async {
    state = AsyncValue.data(wrapper);
    _saveCanteen(wrapper);
  }

  _saveCanteen(SelectedCanteenWrapper wrapper) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "selected-canteen",
      wrapper.isAutomatic ? "" : wrapper.canteen?.enumName ?? "",
    );
  }

  _setToNearest() async {
    final logger = Logger("SelectedCanteenWrapper");

    final locationService = getIt<LocationService>();
    Position? position;

    try {
      position = await locationService.determinePosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e, stacktrace) {
      logger.warning("Failed to get Location", e, stacktrace);
      set(SelectedCanteenWrapper(isAutomatic: true, hasError: true));
      return;
    }

    final canteens = await ref.read(canteensProvider.future);

    final nearest = canteens
        .map(
          (e) => (
            e,
            e.location.distanceTo(position!.latitude, position.longitude),
          ),
        )
        .toList();

    nearest.sort((a, b) => a.$2.compareTo(b.$2));

    final nearestCanteen = nearest.first.$1;
    logger.info(
      "Found nearest Canteen $nearestCanteen. Location: lat. ${position.latitude}, lon. ${position.longitude}",
    );

    set(
      SelectedCanteenWrapper(
        isAutomatic: true,
        canteen: nearestCanteen,
      ),
    );
  }
}
