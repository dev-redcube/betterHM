import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'canteen_service.g.dart';

const showCanteens = [
  "MENSA_ARCISSTR",
  "MENSA_GARCHING",
  "MENSA_LEOPOLDSTR",
  "MENSA_LOTHSTR",
  "MENSA_MARTINSRIED",
  "MENSA_PASING",
  "MENSA_WEIHENSTEPHAN",
  "STUBISTRO_ARCISSTR",
  "STUBISTRO_GOETHESTR",
  "STUBISTRO_GROSSHADERN",
  "STUBISTRO_ROSENHEIM",
  "STUBISTRO_SCHELLINGSTR",
  "STUBISTRO_MARTINSRIED",
  "STUCAFE_ADALBERTSTR",
  "STUCAFE_AKADEMIE_WEIHENSTEPHAN",
  "STUCAFE_CONNOLLYSTR",
  "STUCAFE_GARCHING",
  "STUCAFE_KARLSTR",
  "MENSA_STRAUBING",
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
  Future<SelectedCanteenProvider> build() async {
    final canteens = await ref.watch(canteensProvider.future);
    final prefs = await SharedPreferences.getInstance();
    String? canteenEnum = prefs.getString("selected-canteen");
    final Canteen? canteen = canteens.firstWhereOrNull(
      (element) => element.enumName == canteenEnum,
    );

    final isAutomatic = canteen == null;

    if (isAutomatic) _setToNearest();

    return SelectedCanteenProvider(
      isAutomatic: canteen == null,
      canteen: canteen,
    );
  }

  void set(SelectedCanteenProvider provider) {
    _setState(provider);

    if (provider.isAutomatic && provider.canteen == null) _setToNearest();
  }

  _setState(SelectedCanteenProvider provider) async {
    state = AsyncValue.data(provider);
    _saveCanteen(provider);
  }

  _saveCanteen(SelectedCanteenProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "selected-canteen",
      provider.isAutomatic ? "" : provider.canteen?.enumName ?? "",
    );
  }

  _setToNearest() async {
    final position = await LocationService()
        .determinePosition(desiredAccuracy: LocationAccuracy.medium);

    final canteens = await ref.read(canteensProvider.future);

    final nearest = canteens
        .map(
          (e) => (
            e,
            e.location.distanceTo(position.latitude, position.longitude),
          ),
        )
        .toList();

    nearest.sort((a, b) => a.$2.compareTo(b.$2));
    final nearestCanteen = nearest.first.$1;

    set(
      SelectedCanteenProvider(
        isAutomatic: true,
        canteen: nearestCanteen,
      ),
    );
  }
}

class SelectedCanteenProvider {
  final bool isAutomatic;
  final Canteen? canteen;

  SelectedCanteenProvider({required this.isAutomatic, this.canteen});
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
