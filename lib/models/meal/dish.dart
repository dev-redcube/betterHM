import 'package:better_hm/models/meal/prices.dart';

class Dish {
  final String name;
  final MealPrices prices;
  final String dishType;

  Dish(this.name, this.prices, this.dishType);

  static Dish fromJson(Map<String, dynamic> json) => Dish(
        json["name"],
        MealPrices.fromJson(json["prices"]),
        json["dish_type"],
      );
}
