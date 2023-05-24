import 'package:better_hm/models/meal/label.dart';
import 'package:better_hm/models/meal/prices.dart';

class Dish {
  final String name;
  final MealPrices prices;
  final String dishType;
  final Labels labels;

  Dish(this.name, this.prices, this.dishType, this.labels);

  static Dish fromJson(Map<String, dynamic> json) => Dish(
        json["name"],
        MealPrices.fromJson(json["prices"]),
        json["dish_type"],
        Labels.fromStringList(
            (json["labels"] as List).map((e) => e.toString()).toList()),
      );
}
