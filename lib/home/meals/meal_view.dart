import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/home/meals/models/dish.dart';
import 'package:better_hm/home/meals/models/label.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';

class MealView extends StatelessWidget {
  const MealView({super.key, required this.day});

  final MealDay day;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView(
        shrinkWrap: true,
        children: day.dishes
            .where(
                (element) => !["Aktion", "Beilagen"].contains(element.dishType))
            .map((dish) => DishCard(dish: dish))
            .toList(),
      ),
    );
  }
}

class DishCard extends StatefulWidget {
  const DishCard({
    Key? key,
    required this.dish,
  }) : super(key: key);

  final Dish dish;

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  @override
  void initState() {
    super.initState();
    Prefs.showFoodLabels.addListener(onPrefChange);
  }

  onPrefChange() {
    setState(() {});
  }

  @override
  void dispose() {
    Prefs.showFoodLabels.removeListener(onPrefChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            color: context.theme.colorScheme.primaryContainer),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 8.0),
                        child: Text(widget.dish.dishType),
                      ),
                    ),
                  ),
                  if (Prefs.showFoodLabels.value)
                    GestureDetector(
                      child: Text(widget.dish.labels.asIcons().join(" ")),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text("Legende"),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: labelIcons.entries
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                "${e.value}  ${labelLocals[e.key]}",
                                                style: context
                                                    .theme.textTheme.bodyLarge,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.dish.name,
                      style: context.theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
