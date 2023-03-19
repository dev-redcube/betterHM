import 'package:isar/isar.dart';

class MealPrice {
  final float? basePrice;
  final float? pricePerUnit;
  final String? unit;

  MealPrice(this.basePrice, this.pricePerUnit, this.unit);

  static MealPrice fromJson(Map<String, dynamic> json) => MealPrice(
        json["base_price"],
        json["price_per_unit"],
        json["unit"],
      );
}
