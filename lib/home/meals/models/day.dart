import 'package:better_hm/home/meals/models/dish.dart';
import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

@JsonSerializable()
class MealDays {
  @JsonKey(name: "days")
  final List<MealDay> mealDays;

  MealDays({required this.mealDays});

  factory MealDays.fromJson(Map<String, dynamic> json) =>
      _$MealDaysFromJson(json);

  Map<String, dynamic> toJson() => _$MealDaysToJson(this);
}

@JsonSerializable()
class MealDay {
  final DateTime date;
  final List<Dish> dishes;

  MealDay(this.date, this.dishes);

  factory MealDay.fromJson(Map<String, dynamic> json) =>
      _$MealDayFromJson(json);

  Map<String, dynamic> toJson() => _$MealDayToJson(this);

  @override
  String toString() => "MealDay(date: $date, dishes: $dishes)";
}
