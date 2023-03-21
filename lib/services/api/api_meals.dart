import 'dart:convert';

import 'package:hm_app/exceptions/api_exception.dart';
import 'package:hm_app/models/meal/canteen.dart';
import 'package:hm_app/models/meal/week.dart';
import 'package:hm_app/services/api/api_service.dart';

class ApiMealplan extends ApiService {
  static const baseUrl = "https://tum-dev.github.io/eat-api";

  Future<MealWeek> getMeals(String canteen, int year, int week) async {
    final response = await get(
        "https://tum-dev.github.io/eat-api/$canteen/$year/$week.json");
    if (200 == response.statusCode) {
      Map<String, dynamic> mealWeek =
          jsonDecode(utf8.decode(response.bodyBytes));
      return MealWeek.fromJson(mealWeek);
    } else {
      throw ApiException(statusCode: response.statusCode);
    }
  }

  Future<List<Canteen>> getCanteens() async {
    final response = await get("$baseUrl/enums/canteens.json");
    if (200 == response.statusCode) {
      final List canteens = jsonDecode(utf8.decode(response.bodyBytes));
      return canteens
          .map((canteen) => Canteen.fromJson(canteen as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(statusCode: response.statusCode);
    }
  }
}
