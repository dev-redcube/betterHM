import 'package:better_hm/home/meals/models/dish.dart';

class MealDay {
  final DateTime date;
  final List<Dish> dishes;

  MealDay(this.date, this.dishes);

  static MealDay fromJson(Map<String, dynamic> json) => MealDay(
        DateTime.parse(json["date"]),
        (json["dishes"] as List<dynamic>).map((e) => Dish.fromJson(e)).toList(),
      );
}
