import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/canteenComponent/services/canteen_service.dart';
import 'package:better_hm/canteenComponent/services/mealplan_service.dart';
import 'package:better_hm/main.dart';
import 'package:flutter_test/flutter_test.dart';

/// Just for development
/// TODO remove
void main() {
  getIt.registerSingleton(RestClient());

  test("api works", () async {
    final canteens = await CanteenService.fetchCanteens();

    final canteen = canteens.data.first;

    print(canteen);

    final meals = await MealplanService.fetchMeals(canteen);

    print(meals);
  });
}
