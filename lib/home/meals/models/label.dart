import 'package:redcube_campus/i18n/strings.g.dart';

class Label {
  final String label;

  Label(this.label);

  String? get icon => labelIcons[label];

  String? get translated => labelLocals[label];

  @override
  String toString() => label;

  factory Label.fromJson(String label) => Label(label);

  String toJson() => label;
}

const Map<String, String> labelIcons = {
  "ALCOHOL": "🍷",
  "BEEF": "🐄",
  "MEAT": "🍖",
  "MILK": "🥛",
  "PORK": "🐷",
  "VEGAN": "🌿",
  "VEGETARIAN": "🌱",
};

Map<String, String> labelLocals = {
  "ALCOHOL": t.mealplan.labels.alcohol,
  "BEEF": t.mealplan.labels.beef,
  "MEAT": t.mealplan.labels.meat,
  "MILK": t.mealplan.labels.milk,
  "PORK": t.mealplan.labels.pork,
  "VEGAN": t.mealplan.labels.vegan,
  "VEGETARIAN": t.mealplan.labels.vegetarian,
};
