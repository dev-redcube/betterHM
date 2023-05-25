import 'package:better_hm/i18n/strings.g.dart';

class Labels {
  final List<Label> labels;

  Labels(this.labels);

  factory Labels.fromStringList(List<String> labels) =>
      Labels(labels.map((e) => Label(e)).toList());

  List<String> asIcons() {
    return labels
        .map((e) => e.icon)
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }
}

class Label {
  final String label;

  Label(this.label);

  String? get icon => labelIcons[label];

  String? get translated => labelLocals[label];

  @override
  String toString() => label;
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
