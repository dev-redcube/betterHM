import 'package:json_annotation/json_annotation.dart';
import 'package:redcube_campus/home/meals/models/price.dart';

part 'prices.g.dart';

@JsonSerializable()
class MealPrices {
  final MealPrice? students;
  final MealPrice? staff;
  final MealPrice? guests;

  MealPrices(this.students, this.staff, this.guests);

  factory MealPrices.fromJson(Map<String, dynamic> json) =>
      _$MealPricesFromJson(json);

  Map<String, dynamic> toJson() => _$MealPricesToJson(this);
}
