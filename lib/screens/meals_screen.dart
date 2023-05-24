import 'package:better_hm/components/meals/canteen_info.dart';
import 'package:better_hm/components/meals/canteen_picker.dart';
import 'package:better_hm/components/meals/meal_view.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/models/meal/day.dart';
import 'package:better_hm/providers/selected_canteen.dart';
import 'package:better_hm/services/api/api_meals.dart';
import 'package:better_hm/services/canteen_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Canteen>>(
      future: CanteenService().getCanteens(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return _Body(canteens: snapshot.data!);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, required this.canteens}) : super(key: key);

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
                  child: Text(context.l10n.choose_canteen),
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
  const _MealsPageView({Key? key, required this.canteen}) : super(key: key);

  final Canteen canteen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiMeals().getCombinedMeals(canteen),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        final days = snapshot.data!;
        return PageView(
          children: days
              .map((MealDay day) => _MealsPage(canteen: canteen, day: day))
              .toList(),
        );
      },
    );
  }
}
