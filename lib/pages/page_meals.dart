import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hm_app/models/meal/canteen.dart';
import 'package:hm_app/models/meal/day.dart';
import 'package:hm_app/models/meal/dish.dart';
import 'package:hm_app/services/api/api_meals.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              child: const Text("fetch Api"),
              onPressed: () async {
                final mealWeek =
                    await ApiMealplan().getMeals("mensa-lothstr", 2023, 11);
              },
            ),
            CanteenInfo(
              canteen: Canteen.fromJson(jsonDecode(
                  '{"enum_name":"MENSA_GARCHING","name":"MensaGarching","location":{"address":"Boltzmannstraße19,Garching","latitude":48.268132,"longitude":11.672263},"canteen_id":"mensa-garching","queue_status":"https://mensa.liste.party/api/","open_hours":{"mon":{"start":"11:00","end":"14:00"},"tue":{"start":"11:00","end":"14:00"},"wed":{"start":"11:00","end":"14:00"},"thu":{"start":"11:00","end":"14:00"},"fri":{"start":"11:00","end":"14:00"}}}')),
              date: DateTime.now(),
            ),
            const SizedBox(height: 8),
            Meals(
                day: MealDay.fromJson(jsonDecode(
                    '{"date":"2023-03-20","dishes":[{"name":"QuinoapfannemitGemüseundChili(scharf)","prices":{"students":{"base_price":1,"price_per_unit":null,"unit":null},"staff":{"base_price":2.25,"price_per_unit":null,"unit":null},"guests":{"base_price":3.1,"price_per_unit":null,"unit":null}},"labels":["VEGAN","VEGETARIAN"],"dish_type":"Tagesgericht1"},{"name":"GnocchimitTomatensauce","prices":{"students":{"base_price":2.05,"price_per_unit":null,"unit":null},"staff":{"base_price":2.85,"price_per_unit":null,"unit":null},"guests":{"base_price":3.9,"price_per_unit":null,"unit":null}},"labels":["CEREAL","GARLIC","GLUTEN","VEGAN","VEGETARIAN","WHEAT"],"dish_type":"Tagesgericht3"},{"name":"BernerRöstigratinmitKräuterdip","prices":{"students":null,"staff":null,"guests":null},"labels":["CHICKEN_EGGS","GARLIC","LACTOSE","MILK","VEGETARIAN"],"dish_type":"Aktionsessen3"},{"name":"Schweinelachssteak(SvomStrohschwein)mitscharfemGemüsedip","prices":{"students":null,"staff":null,"guests":null},"labels":["MEAT"],"dish_type":"Aktionsessen6"},{"name":"BoeufStroganoffmitSenf,SchnitzelgurkenundChampignons","prices":{"students":null,"staff":null,"guests":null},"labels":["BEEF","CEREAL","GLUTEN","LACTOSE","MEAT","MILK","MUSTARD","SWEETENERS","WHEAT"],"dish_type":"Aktionsessen8"},{"name":"Tagessuppe","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["MEAT"],"dish_type":"Beilagen"},{"name":"Gurkensalat","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["ANTIOXIDANTS","SULFITES","SULPHURS","VEGAN","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"Tomatensalat","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["ANTIOXIDANTS","SULFITES","SULPHURS","VEGAN","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"Reis","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["VEGAN","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"Nudeln","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["CEREAL","GLUTEN","VEGAN","VEGETARIAN","WHEAT"],"dish_type":"Beilagen"},{"name":"VanillecrememitSauerkirschen","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["LACTOSE","MILK","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"SaisonaleBeilagensalate","prices":{"students":null,"staff":null,"guests":null},"labels":["VEGAN","VEGETARIAN"],"dish_type":"Aktion"},{"name":"Knöpfle","prices":{"students":null,"staff":null,"guests":null},"labels":["CEREAL","CHICKEN_EGGS","GLUTEN","SPELT","VEGETARIAN","WHEAT"],"dish_type":"Aktion"},{"name":"Countrykartoffeln","prices":{"students":null,"staff":null,"guests":null},"labels":["VEGETARIAN"],"dish_type":"Aktion"},{"name":"Ayran","prices":{"students":null,"staff":null,"guests":null},"labels":["LACTOSE","MILK","VEGETARIAN"],"dish_type":"Aktion"},{"name":"FrischerRahmkohlrabi","prices":{"students":null,"staff":null,"guests":null},"labels":["CEREAL","GLUTEN","LACTOSE","MILK","VEGETARIAN","WHEAT"],"dish_type":"Aktion"}]}')))
          ],
        ),
      ),
    );
  }
}

class CanteenInfo extends StatelessWidget {
  const CanteenInfo({Key? key, required this.canteen, required this.date})
      : super(key: key);

  final Canteen canteen;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final openingTimes = canteen.openHours?[date.weekday];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMMEEEEd().format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (openingTimes != null)
          Text(
            "${openingTimes.start} - ${openingTimes.end}",
            style: const TextStyle(color: Colors.green),
          ),
      ],
    );
  }
}

class Meals extends StatelessWidget {
  const Meals({super.key, required this.day});

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}

class DishRow extends StatelessWidget {
  const DishRow({super.key, required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(dish.name),
      ],
    );
  }
}
