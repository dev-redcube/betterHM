import 'package:better_hm/models/meal/day.dart';

class MealWeek {
  final int number;
  final int year;
  final List<MealDay> days;

  MealWeek(this.number, this.year, this.days);

  static MealWeek fromJson(Map<String, dynamic> json) => MealWeek(
        json["number"],
        json["year"],
        (json["days"] as List<dynamic>)
            .map((e) => MealDay.fromJson(e))
            .toList(),
      );
}
