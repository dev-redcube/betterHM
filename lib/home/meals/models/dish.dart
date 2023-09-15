import 'package:better_hm/home/meals/models/label.dart';
import 'package:better_hm/home/meals/models/prices.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dish.g.dart';

@JsonSerializable()
class Dish {
  final String name;
  final MealPrices prices;
  @JsonKey(name: "dish_type")
  final String dishType;
  final List<Label> labels;

  Dish(this.name, this.prices, this.dishType, this.labels);

  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);

  Map<String, dynamic> toJson() => _$DishToJson(this);

  List<String> labelsAsIcons() {
    return labels
        .map((e) => e.icon)
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }
}
