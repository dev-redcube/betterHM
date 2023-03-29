import 'package:flutter/material.dart';
import 'package:better_hm/models/meal/day.dart';
import 'package:better_hm/models/meal/dish.dart';

class MealView extends StatelessWidget {
  const MealView({super.key, required this.day});

  final MealDay day;

  Map<String, List<Dish>> groupDishes() {
    final Map<String, List<Dish>> grouped = {};

    for (var element in day.dishes) {
      grouped[element.dishType] == null
          ? grouped[element.dishType] = [element].toList()
          : grouped[element.dishType]!.add(element);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: groupDishes()
          .map((dishType, dishes) => MapEntry(
              dishType,
              DishSection(
                dishType: dishType,
                dishes: dishes,
              )))
          .values
          .toList(),
    );
  }
}

class DishSection extends StatelessWidget {
  const DishSection({super.key, required this.dishType, required this.dishes});

  final String dishType;
  final List<Dish> dishes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                dishType,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: dishes.map((dish) => DishRow(dish: dish)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DishRow extends StatelessWidget {
  const DishRow({super.key, required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Text(dish.name);
  }
}
