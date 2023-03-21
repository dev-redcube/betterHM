import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_app/components/meals/canteen_info.dart';
import 'package:hm_app/components/meals/canteen_picker.dart';
import 'package:hm_app/components/meals/meal_view.dart';
import 'package:hm_app/cubits/cubit_cantine.dart';
import 'package:hm_app/models/meal/canteen.dart';
import 'package:hm_app/models/meal/day.dart';
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
    return BlocProvider(
      create: (_) => CanteenCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: ApiMealplan().getCanteens(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CanteenPicker(
                    canteens: snapshot.data!, context: context);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        body: BlocBuilder<CanteenCubit, Canteen?>(
          builder: (context, canteen) {
            if (canteen == null) {
              return const Center(
                child: Text("please select a canteen"),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MealsPages(canteen: canteen),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MealsPages extends StatelessWidget {
  MealsPages({super.key, required this.canteen});

  final Canteen canteen;
  final _controller = PageController();

  final Map<String, MealDay> mealDays = {};

  MealDay getCurrentDay() {
    return MealDay.fromJson(jsonDecode(
        '{"date":"2023-03-20","dishes":[{"name":"QuinoapfannemitGemüseundChili(scharf)","prices":{"students":{"base_price":1,"price_per_unit":null,"unit":null},"staff":{"base_price":2.25,"price_per_unit":null,"unit":null},"guests":{"base_price":3.1,"price_per_unit":null,"unit":null}},"labels":["VEGAN","VEGETARIAN"],"dish_type":"Tagesgericht1"},{"name":"GnocchimitTomatensauce","prices":{"students":{"base_price":2.05,"price_per_unit":null,"unit":null},"staff":{"base_price":2.85,"price_per_unit":null,"unit":null},"guests":{"base_price":3.9,"price_per_unit":null,"unit":null}},"labels":["CEREAL","GARLIC","GLUTEN","VEGAN","VEGETARIAN","WHEAT"],"dish_type":"Tagesgericht3"},{"name":"BernerRöstigratinmitKräuterdip","prices":{"students":null,"staff":null,"guests":null},"labels":["CHICKEN_EGGS","GARLIC","LACTOSE","MILK","VEGETARIAN"],"dish_type":"Aktionsessen3"},{"name":"Schweinelachssteak(SvomStrohschwein)mitscharfemGemüsedip","prices":{"students":null,"staff":null,"guests":null},"labels":["MEAT"],"dish_type":"Aktionsessen6"},{"name":"BoeufStroganoffmitSenf,SchnitzelgurkenundChampignons","prices":{"students":null,"staff":null,"guests":null},"labels":["BEEF","CEREAL","GLUTEN","LACTOSE","MEAT","MILK","MUSTARD","SWEETENERS","WHEAT"],"dish_type":"Aktionsessen8"},{"name":"Tagessuppe","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["MEAT"],"dish_type":"Beilagen"},{"name":"Gurkensalat","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["ANTIOXIDANTS","SULFITES","SULPHURS","VEGAN","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"Tomatensalat","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["ANTIOXIDANTS","SULFITES","SULPHURS","VEGAN","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"Reis","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["VEGAN","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"Nudeln","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["CEREAL","GLUTEN","VEGAN","VEGETARIAN","WHEAT"],"dish_type":"Beilagen"},{"name":"VanillecrememitSauerkirschen","prices":{"students":{"base_price":0,"price_per_unit":0.8,"unit":"100g"},"staff":{"base_price":0,"price_per_unit":1,"unit":"100g"},"guests":{"base_price":0,"price_per_unit":1.35,"unit":"100g"}},"labels":["LACTOSE","MILK","VEGETARIAN"],"dish_type":"Beilagen"},{"name":"SaisonaleBeilagensalate","prices":{"students":null,"staff":null,"guests":null},"labels":["VEGAN","VEGETARIAN"],"dish_type":"Aktion"},{"name":"Knöpfle","prices":{"students":null,"staff":null,"guests":null},"labels":["CEREAL","CHICKEN_EGGS","GLUTEN","SPELT","VEGETARIAN","WHEAT"],"dish_type":"Aktion"},{"name":"Countrykartoffeln","prices":{"students":null,"staff":null,"guests":null},"labels":["VEGETARIAN"],"dish_type":"Aktion"},{"name":"Ayran","prices":{"students":null,"staff":null,"guests":null},"labels":["LACTOSE","MILK","VEGETARIAN"],"dish_type":"Aktion"},{"name":"FrischerRahmkohlrabi","prices":{"students":null,"staff":null,"guests":null},"labels":["CEREAL","GLUTEN","LACTOSE","MILK","VEGETARIAN","WHEAT"],"dish_type":"Aktion"}]}'));
  }

  MealDay getDay(DateTime date) {
    final dateString = DateFormat("yyyy-MM-dd").format(date);
    if (mealDays.containsKey(dateString)) {
      return mealDays[dateString]!;
    } else {
      // TODO fetch from api
      // return getDay(date);
    }

    return getCurrentDay();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _controller,
        itemBuilder: (BuildContext context, int page) {
          if (page == 5) return null;
          final DateTime now = DateTime.now();
          final DateTime date =
              DateTime(now.year, now.month, now.day).add(Duration(days: page));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CanteenInfo(canteen: canteen, date: date),
              MealView(
                day: getDay(date),
              )
            ],
          );
        },
      ),
    );
  }
}
