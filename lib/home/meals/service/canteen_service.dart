import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/home/meals/service/selected_canteen_wrapper.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'canteen_service.g.dart';

const showCanteens = [
  "MENSA_LOTHSTR",
  "MENSA_PASING",
  "STUCAFE_KARLSTR",
  "MENSA_ARCISSTR",
  "MENSA_GARCHING",
  "STUCAFE_GARCHING",
];

@riverpod
Future<List<Canteen>> canteens(Ref ref) async {
  MainApi mainApi = getIt<MainApi>();

  final uri = Uri(
    scheme: "https",
    host: "tum-dev.github.io",
    path: "/eat-api/enums/canteens.json",
  );

  final response = await mainApi.get(uri, Canteens.fromJson);

  final canteens = response.data.canteens
      .where((element) => showCanteens.contains(element.enumName))
      .toList();

  // sort by order of showCanteens
  return [
    for (final item in showCanteens)
      canteens.firstWhere((e) => e.enumName == item),
  ];
}

@riverpod
Future<List<MealDay>?> meals(Ref ref) async {
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

  final today = DateTime.now().withoutTime;
  return response.data.mealDays.where((e) => e.date >= today).toList();
}

Future<double?> capacity(Canteen canteen) async {
  final mainApi = getIt<MainApi>();
  final uri = Uri(
    scheme: "https",
    host: "api.betterhm.app",
    path: "/v1/capacity/${canteen.enumName}",
  );

  final response = await mainApi.getNeverCache(
    uri,
    (json) {
      try {
        double percentage = json["percent"];
        final p = percentage / 100;
        return p;
      } catch (exception, stacktrace) {
        Logger("CapacityService").severe("Parser fail", exception, stacktrace);
        rethrow;
      }
    },
  );

  return response.data;
}
