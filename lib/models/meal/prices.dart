import 'package:better_hm/models/meal/price.dart';

class MealPrices {
  final MealPrice? students;
  final MealPrice? staff;
  final MealPrice? guests;

  MealPrices(this.students, this.staff, this.guests);

  static MealPrices fromJson(Map<String, dynamic> json) {
    return MealPrices(
      json["students"] == null ? null : MealPrice.fromJson(json["students"]),
      json["staff"] == null ? null : MealPrice.fromJson(json["staff"]),
      json["guests"] == null ? null : MealPrice.fromJson(json["guests"]),
    );
  }
}
