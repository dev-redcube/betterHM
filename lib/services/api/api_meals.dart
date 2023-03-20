import 'dart:convert';

import 'package:hm_app/exceptions/api_exception.dart';
import 'package:hm_app/models/meal/week.dart';
import 'package:hm_app/services/api/api_service.dart';

class ApiMealplan extends ApiService {
  Future<MealWeek> getMeals(String mensa, int year, int week) async {
    final response =
        await get("https://tum-dev.github.io/eat-api/$mensa/$year/$week.json");
    if (200 == response.statusCode) {
      Map<String, dynamic> mealWeek =
          jsonDecode(utf8.decode(response.bodyBytes));
      return MealWeek.fromJson(mealWeek);
    } else {
      throw ApiException(statusCode: response.statusCode);
    }
  }
}
