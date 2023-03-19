import 'package:hm_app/models/meal/prices.dart';

class Dish {
  final String name;
  final MealPrices prices;

  Dish(this.name, this.prices);

  static Dish fromJson(Map<String, dynamic> json) => Dish(
        json["name"],
        MealPrices.fromJson(json["prices"]),
      );
}
