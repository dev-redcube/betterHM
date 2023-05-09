import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/models/meal/day.dart';
import 'package:better_hm/models/meal/dish.dart';
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

class DishCard extends StatelessWidget {
  const DishCard({
    Key? key,
    required this.dish,
  }) : super(key: key);

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  color: context.theme.colorScheme.primaryContainer
                ),
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Text(dish.dishType),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      dish.name,
                      style: context.theme.textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}