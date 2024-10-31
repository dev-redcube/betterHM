import 'package:better_hm/canteenComponent/models/dish.dart';
import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

class MealPlan {
  static List<MealDay> parse(Map<String, dynamic> json) {
    final weeks = json["weeks"];

    final List<MealDay> days = [];

    for (final week in weeks) {
      days.addAll(MealDays.fromJson(week).mealDays);
    }

    return days;
  }
}

@JsonSerializable(createToJson: false)
class MealDays {
  @JsonKey(name: "days")
  final List<MealDay> mealDays;

  MealDays({required this.mealDays});

  factory MealDays.fromJson(Map<String, dynamic> json) =>
      _$MealDaysFromJson(json);
}

@JsonSerializable(createToJson: false)
class MealDay {
  final DateTime date;
  final List<Dish> dishes;

  MealDay(this.date, this.dishes);

  factory MealDay.fromJson(Map<String, dynamic> json) =>
      _$MealDayFromJson(json);

  @override
  String toString() => "MealDay(date: $date, dishes: $dishes)";
}
