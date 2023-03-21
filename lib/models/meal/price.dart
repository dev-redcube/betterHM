class MealPrice {
  final double? basePrice;
  final double? pricePerUnit;
  final String? unit;

  MealPrice(this.basePrice, this.pricePerUnit, this.unit);

  static MealPrice fromJson(Map<String, dynamic> json) => MealPrice(
        json["base_price"] == null
            ? null
            : double.parse(json["base_price"].toString()),
        json["price_per_unit"] == null
            ? null
            : double.parse(json["price_per_unit"].toString()),
        json["unit"],
      );
}
