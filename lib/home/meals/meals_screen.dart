import 'package:better_hm/home/meals/canteen_info.dart';
import 'package:better_hm/home/meals/canteen_picker.dart';
import 'package:better_hm/home/meals/meal_view.dart';
import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/home/meals/selected_canteen_provider.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/home/meals/service/meal_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              context.pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<(DateTime?, List<Canteen>)>(
        future: CanteenService.fetchCanteens(false),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return _Body(
            lastUpdated: snapshot.data!.$1,
            canteens: snapshot.data!.$2,
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.lastUpdated, required this.canteens});

  final DateTime? lastUpdated;
  final List<Canteen> canteens;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => SelectedCanteenProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: CanteenPicker(
              canteens: canteens,
            ),
          ),
          body: Consumer<SelectedCanteenProvider>(
            builder: (context, provider, child) {
              if (provider.canteen == null) {
                return Center(
                  child: Text(t.mealplan.choose_canteen),
                );
              }
              return _MealsPageView(
                canteen: provider.canteen!,
              );
            },
          ),
        ),
      );
}

class _MealsPage extends StatelessWidget {
  const _MealsPage({required this.canteen, required this.day});

  final Canteen canteen;
  final MealDay day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CanteenInfo(canteen: canteen, date: day.date),
          Flexible(flex: 1, child: MealView(day: day)),
        ],
      ),
    );
  }
}

class _MealsPageView extends StatelessWidget {
  const _MealsPageView({required this.canteen});

  final Canteen canteen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MealService.getMeals(canteen, false),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        final data = snapshot.data!;
        if (data.$2.isEmpty) {
          return Center(
            child: Text(t.mealplan.no_meals),
          );
        }
        return PageView(
          children: data.$2
              .skipWhile(
                (value) => value.date.isBefore(DateTime.now().withoutTime),
              )
              .map((MealDay day) => _MealsPage(canteen: canteen, day: day))
              .toList(),
        );
      },
    );
  }
}
