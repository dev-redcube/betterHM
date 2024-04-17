import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'canteen_service.g.dart';

const showCanteens = [
  "MENSA_LOTHSTR",
  "MENSA_PASING",
  "STUCAFE_KARLSTR",
];

@riverpod
Future<List<Canteen>> canteens(CanteensRef ref) async {
  MainApi mainApi = getIt<MainApi>();

  final uri = Uri(
    scheme: "https",
    host: "tum-dev.github.io",
    path: "/eat-api/enums/canteens.json",
  );

  final response = await mainApi.get(uri, Canteens.fromJson);

  return response.data.canteens
      .where((element) => showCanteens.contains(element.enumName))
      .toList();
}

@riverpod
class SelectedCanteen extends _$SelectedCanteen {
  @override
  FutureOr<SelectedCanteenProvider> build() async {
    final canteens = await ref.watch(canteensProvider.future);
    final lastCanteen = Prefs.lastCanteen.value;

    if (lastCanteen.isEmpty) {
      _nearestCanteen();
      return SelectedCanteenProvider(
        locationState: LiveLocationState.searching,
      );
    }

    final Canteen canteen =
        canteens.firstWhere((element) => element.enumName == lastCanteen);
    return SelectedCanteenProvider(
      locationState: LiveLocationState.off,
      canteen: canteen,
    );
  }

  void _nearestCanteen() async {
    final logger = Logger("SelectedCanteen");
    final canteens = await ref.read(canteensProvider.future);

    final locationService = getIt<LocationService>();
    Position? position;

    try {
      position = await locationService.getLastKnownOrNew(
        LocationAccuracy.medium,
      );
    } catch (e, stacktrace) {
      logger.warning("Failed to get location", e, stacktrace);
      state = AsyncData(
        SelectedCanteenProvider(locationState: LiveLocationState.error),
      );
      return;
    }

    final nearest = canteens
        .map(
          (e) => (
            e,
            e.location.distanceTo(position!.latitude, position.longitude)
          ),
        )
        .toList();

    nearest.sort((a, b) => a.$2.compareTo(b.$2));
    final nearestCanteen = nearest.firstOrNull?.$1;
    if (nearestCanteen != null) {
      logger.info(
        "Nearest Canteen: ${nearestCanteen.name}. Location: lat. ${position.latitude} lon. ${position.longitude}. Accuracy: ${position.accuracy}",
      );
    } else {
      logger.warning(
        "Failed to get nearest Station. Location: lat. ${position.latitude} lon. ${position.longitude}. Accuracy: ${position.accuracy}",
      );
    }

    state = AsyncData(
      SelectedCanteenProvider(
        locationState: LiveLocationState.found,
        canteen: nearestCanteen,
      ),
    );
  }

  void set(SelectedCanteenProvider provider) {
    if (provider.locationState != LiveLocationState.off) {
      return _nearestCanteen();
    }

    state = AsyncValue.data(provider);
    Prefs.lastCanteen.value = provider.canteen?.enumName ?? "";
  }
}

class SelectedCanteenProvider {
  final LiveLocationState locationState;
  final Canteen? canteen;

  SelectedCanteenProvider({required this.locationState, this.canteen});
}

@riverpod
Future<List<MealDay>?> meals(MealsRef ref) async {
  final selectedCanteen = await ref.watch(selectedCanteenProvider.future);
  if (selectedCanteen.canteen == null) return null;

  MainApi mainApi = getIt<MainApi>();
  final uri = Uri(
    scheme: "https",
    host: "tum-dev.github.io",
    path:
        "/eat-api/${selectedCanteen.canteen!.canteenId}/combined/combined.json",
  );

  final response = await mainApi.get(uri, (json) {
    try {
      List weeks = json["weeks"];
      List days = weeks.fold(
        [],
        (previousValue, element) => previousValue..addAll(element["days"]),
      );
      return MealDays.fromJson({"days": days});
    } catch (exception, stacktrace) {
      Logger("EatService")
          .severe("Eatservice Parser fail", exception, stacktrace);
      rethrow;
    }
  });

  return response.data.mealDays;
}
