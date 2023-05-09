import 'package:better_hm/components/meals/canteen_info.dart';
import 'package:better_hm/components/meals/canteen_picker.dart';
import 'package:better_hm/components/meals/meal_view.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/extensions/extensions_date_time.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/providers/selected_canteen.dart';
import 'package:better_hm/services/api/api_meals.dart';
import 'package:better_hm/services/canteen_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  child: Text(context.localizations.choose_canteen),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _MealsPage(
                  canteen: provider.canteen!,
                ),
              );
            },
          ),
        ),
      );
}

class _MealsPage extends StatelessWidget {
  const _MealsPage({required this.canteen});

  final Canteen canteen;

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
        late final Widget child;
        try {
          final day = snapshot.data!.days
              .firstWhere((element) => element.date == today());
          child = MealView(day: day);
        } catch (e) {
          child = Center(
            child: Text(context.localizations.no_meals),
          );
        }

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CanteenInfo(canteen: canteen, date: today()),
              Flexible(
                flex: 1,
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}
