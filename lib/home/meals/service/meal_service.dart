import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/networking/apis/eat_api/eat_api.dart';
import 'package:better_hm/shared/networking/apis/eat_api/eat_api_service.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:logging/logging.dart';

class MealService {
  static Future<(DateTime?, List<MealDay>)> getMeals(
    Canteen canteen,
    bool forcedRefresh,
  ) async {
    MainApi mainApi = getIt<MainApi>();
    final response = await mainApi.makeRequest<MealDays, EatApi>(
      EatApi(EatApiServiceMenuCombined(location: canteen.canteenId)),
      (json) {
        try {
          List weeks = json["weeks"];
          List days = weeks.fold(
              [],
              (previousValue, element) =>
                  previousValue..addAll(element["days"]));
          return MealDays.fromJson({"days": days});
        } catch (exception, stacktrace) {
          Logger("EatService")
              .severe("Eatservice Parser fail", exception, stacktrace);
        }
      },
      forcedRefresh,
    );

    return (response.saved, response.data.mealDays);
  }
}
