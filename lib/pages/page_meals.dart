import 'package:better_hm/blocs/canteen/canteen_bloc.dart';
import 'package:better_hm/blocs/canteen/canteen_event.dart';
import 'package:better_hm/blocs/canteen/canteen_state.dart';
import 'package:better_hm/components/meals/canteen_info.dart';
import 'package:better_hm/components/meals/canteen_picker.dart';
import 'package:better_hm/components/meals/meal_view.dart';
import 'package:better_hm/cubits/cubit_cantine.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/extensions/extensions_date_time.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/api/api_canteen.dart';
import 'package:better_hm/services/api/api_meals.dart';
import 'package:better_hm/services/cache/cache_canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CanteenBloc canteenBloc;
  bool isLoading = false;

  List<Canteen> canteens = [];
  final List<Canteen> _fetchedCanteens = [];
  final List<Canteen> _cachedCanteens = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CanteenBloc>(
      create: (context) {
        canteenBloc = CanteenBloc(
            apiCanteen: ApiCanteen(), cacheService: CacheCanteenService());
        canteenBloc.add(FetchCanteens());
        isLoading = true;
        return canteenBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<CanteenBloc, CanteenState>(
            listener: (context, state) {
              if (state is CanteensError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    duration: const Duration(seconds: 5),
                  ),
                );
              } else if (state is CanteensFetched) {
                _fetchedCanteens.addAll(state.canteens);
                canteens = _fetchedCanteens;
              } else if (state is CanteensFetchedFromCache) {
                isLoading = false;
                _cachedCanteens.addAll(state.canteens);
                canteens = _cachedCanteens;
              }
            },
            builder: (context, state) => CanteenPicker(canteens: canteens),
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
  const MealsPages({super.key, required this.canteen});

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
