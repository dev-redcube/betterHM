import 'package:better_hm/canteenComponent/models/canteen.dart';
import 'package:better_hm/canteenComponent/provider/selected_canteen_provider.dart';
import 'package:better_hm/canteenComponent/services/canteen_service.dart';
import 'package:better_hm/canteenComponent/services/mealplan_service.dart';
import 'package:better_hm/home/meals/canteen_picker.dart';
import 'package:better_hm/canteenComponent/widgets/day_picker.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CanteenScreen extends StatelessWidget {
  const CanteenScreen({super.key});

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
      body: FutureBuilder(
        future: CanteenService.fetchCanteens(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();

          return _CanteenScreenBody(canteens: snapshot.data!.data);
        },
      ),
    );
  }
}

class _CanteenScreenBody extends StatelessWidget {
  const _CanteenScreenBody({required this.canteens});

  final List<Canteen> canteens;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox.shrink(),
            CanteenPicker(),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(child: _MealsView()),
      ],
    );
  }
}

class _MealsView extends ConsumerWidget {
  _MealsView();

  final selectedDayController = SelectedDayController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canteen = ref.watch(selectedCanteenProvider).value?.canteen;

    if (canteen == null) return const Text("Select Canteen");

    return FutureBuilder(
      future: MealplanService.fetchMeals(canteen),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          return const CircularProgressIndicator();

        return Column(
          children: [
            DayPicker(
              controller: selectedDayController,
              dates: snapshot.data!.data.map((day) => day.date).toList(),
            ),
          ],
        );
      },
    );
  }
}
