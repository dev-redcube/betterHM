import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_app/components/meals/canteen_info.dart';
import 'package:hm_app/components/meals/canteen_picker.dart';
import 'package:hm_app/components/meals/meal_view.dart';
import 'package:hm_app/cubits/cubit_cantine.dart';
import 'package:hm_app/extensions/extensions_context.dart';
import 'package:hm_app/extensions/extensions_date_time.dart';
import 'package:hm_app/models/meal/canteen.dart';
import 'package:hm_app/services/api/api_meals.dart';

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
            future: ApiMeals().getCanteens(),
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
              return Center(
                child: Text(context.localizations.choose_canteen),
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return FutureBuilder(
        future: ApiMeals().getMealsInWeek(canteen, now.year, now.weekOfYear),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return const LinearProgressIndicator();
          }
          final days = snapshot.data!.days
              .where((element) => element.date
                  .isAfter(today().subtract(const Duration(days: 1))))
              .toList();
          return Expanded(
            child: PageView.builder(
              controller: _controller,
              itemBuilder: (BuildContext context, int page) {
                if (page >= snapshot.data!.days.length) {
                  return null;
                }
                final DateTime now = DateTime.now();
                final DateTime date = DateTime(now.year, now.month, now.day)
                    .add(Duration(days: page));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CanteenInfo(canteen: canteen, date: date),
                    Text("page: $page, length: ${days.length}"),
                    MealView(
                      day: days[page],
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
