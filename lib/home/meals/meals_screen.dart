import 'package:better_hm/home/meals/canteen_picker.dart';
import 'package:better_hm/home/meals/components/day_picker.dart';
import 'package:better_hm/home/meals/meal_view.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

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
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              CanteenPicker(),
            ],
          ),
          const SizedBox(height: 8),
          // TODO
          DayPicker(
            dates: [
              DateTime(2024, 9, 23),
              DateTime.now(),
              DateTime.now().subtract(const Duration(days: 2)),
              DateTime.now().subtract(const Duration(days: 1)),
              DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now().subtract(const Duration(days: 12)),
            ],
            onSelect: (date) {
              print(date);
            },
          ),
          const Expanded(child: _MealsConsumerWrapper()),
        ],
      ),
    );
  }
}

class _MealsConsumerWrapper extends ConsumerWidget {
  const _MealsConsumerWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsProvider);

    switch (meals) {
      case AsyncData(:final value):
        if (value == null) return const SizedBox.shrink();
        return _MealsBody(mealDays: value);
      case _:
        // Loading
        return const SizedBox.shrink();
    }
  }
}

class _MealsBody extends StatelessWidget {
  const _MealsBody({required this.mealDays});

  final List<MealDay> mealDays;

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: mealDays
          .skipWhile(
            (value) => value.date.isBefore(DateTime.now().withoutTime),
          )
          .map(
            (MealDay day) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DayInfo(date: day.date),
                Expanded(child: MealView(day: day)),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _DayInfo extends StatelessWidget {
  const _DayInfo({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        DateFormat.yMMMMEEEEd().format(date),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
