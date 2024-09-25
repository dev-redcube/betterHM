import 'package:better_hm/home/meals/canteen_picker.dart';
import 'package:better_hm/home/meals/components/day_picker.dart';
import 'package:better_hm/home/meals/meal_view.dart';
import 'package:better_hm/home/meals/models/day.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealsScreen extends ConsumerWidget {
  MealsScreen({super.key});

  final dayPickerController = SelectedDayController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsProvider).value;

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
          DayPicker(
            controller: dayPickerController,
            dates: meals?.map((day) => day.date).toList() ?? [],
          ),
          if (meals != null)
            Expanded(
              child: _MealsConsumerWrapper(controller: dayPickerController),
            ),
        ],
      ),
    );
  }
}

class _MealsConsumerWrapper extends ConsumerWidget {
  const _MealsConsumerWrapper({this.controller});

  final SelectedDayController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsProvider);

    switch (meals) {
      case AsyncData(:final value):
        if (value == null) return const SizedBox.shrink();
        return _MealsBody(mealDays: value, controller: controller);
      case _:
        // Loading
        return const SizedBox.shrink();
    }
  }
}

class _MealsBody extends StatefulWidget {
  _MealsBody({required this.mealDays, SelectedDayController? controller})
      : controller = controller ?? SelectedDayController();

  final List<MealDay> mealDays;
  final SelectedDayController controller;

  @override
  State<_MealsBody> createState() => _MealsBodyState();
}

class _MealsBodyState extends State<_MealsBody> {
  final pageController = PageController();

  // Prevents triggering the change while animating from external change
  bool changeBlocker = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(handleExternalDateChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleExternalDateChange);
    super.dispose();
  }

  void handleExternalDateChange() {
    final newDate = widget.controller.selectedDate;
    if (newDate != null) {
      final page = widget.mealDays
          .indexWhereOrNull((meal) => meal.date.sameDayAs(newDate));

      if (page != null) changeBlocker = true;
      pageController
          .animateToPage(
            page!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          )
          .then((_) => changeBlocker = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: (page) {
        if (!changeBlocker)
          widget.controller.selectedDate = widget.mealDays[page].date;
      },
      children: widget.mealDays
          .map(
            (MealDay day) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO Auslastung
                Expanded(child: MealView(day: day)),
              ],
            ),
          )
          .toList(),
    );
  }
}
