import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

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


@JsonSerializable()
class MealPrice {
  final double? basePrice;
  final double? pricePerUnit;
  final String? unit;

  MealPrice(this.basePrice, this.pricePerUnit, this.unit);

  factory MealPrice.fromJson(Map<String, dynamic> json) =>
      _$MealPriceFromJson(json);

  Map<String, dynamic> toJson() => _$MealPriceToJson(this);
}
