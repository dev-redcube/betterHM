import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:logging/logging.dart';

class MealService {
  static Future<(DateTime?, List<MealDay>)> getMeals(
    Canteen canteen,
    bool forcedRefresh,
  ) async {
    MainApi mainApi = getIt<MainApi>();
    // final response = await mainApi.makeRequest<MealDays, EatApi>(
    //   EatApi(EatApiServiceMenuCombined(location: canteen.canteenId)),
    //   (json) {
    //     try {
    //       List weeks = json["weeks"];
    //       List days = weeks.fold(
    //           [],
    //           (previousValue, element) =>
    //               previousValue..addAll(element["days"]));
    //       return MealDays.fromJson({"days": days});
    //     } catch (exception, stacktrace) {
    //       Logger("EatService")
    //           .severe("Eatservice Parser fail", exception, stacktrace);
    //     }
    //   },
    //   forcedRefresh,
    // );
    final uri = Uri(
      scheme: "https",
      host: "tum-dev.github.io",
      path: "/eat-api/${canteen.canteenId}/combined/combined.json",
    );

    final response = await mainApi.get(
      uri,
      (json) {
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
        }
      },
    );

    return (response.saved, response.data!.mealDays);
  }
}
