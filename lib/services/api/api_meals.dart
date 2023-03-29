import 'dart:convert';

import 'package:better_hm/exceptions/api_exception.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/models/meal/day.dart';
import 'package:better_hm/models/meal/week.dart';
import 'package:better_hm/services/api/api_service.dart';

class ApiMeals extends ApiService {
  static const baseUrl = "https://tum-dev.github.io/eat-api";

  Future<MealWeek> getMealsInWeek(Canteen canteen, int year, int week) async {
    final response =
        await get("$baseUrl/${canteen.canteenId}/$year/$week.json");
    if (200 == response.statusCode) {
      Map<String, dynamic> mealWeek =
          jsonDecode(utf8.decode(response.bodyBytes));
      return MealWeek.fromJson(mealWeek);
    } else {
      throw ApiException(statusCode: response.statusCode);
    }
  }

  Future<List<MealDay>> getAllMeals(Canteen canteen) async {
    final response =
        await get("$baseUrl/${canteen.canteenId}/combined/combined.json");
    if (200 == response.statusCode) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      return (data["weeks"] as List<dynamic>)
          .map((e) {
            return MealWeek.fromJson(e);
          })
          .fold([],
              (previousValue, element) => previousValue..addAll(element.days))
          .map((e) => e as MealDay)
          .toList();
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
