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

  @override
  String toString() => label;
}

const Map<String, String> labelIcons = {
  "ALCOHOL": "🍷",
  "BEEF": "🐄",
  "MILK": "🥛",
  "MEAT": "🍖",
  "PORK": "🐷",
  "VEGAN": "🌿",
  "VEGETARIAN": "🌱",
};
