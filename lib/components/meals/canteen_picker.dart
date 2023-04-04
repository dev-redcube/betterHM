import 'package:better_hm/blocs/canteen/canteen_bloc.dart';
import 'package:better_hm/blocs/canteen/canteen_event.dart';
import 'package:better_hm/blocs/canteen/canteen_state.dart';
import 'package:better_hm/cubits/selected_canteen_cubit.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/api/api_canteen.dart';
import 'package:better_hm/services/cache/cache_canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenPicker extends StatefulWidget {
  const CanteenPicker({
    super.key,
  });

  @override
  State<CanteenPicker> createState() => _CanteenPickerState();
}

class _CanteenPickerState extends State<CanteenPicker> {
  late final SelectedCanteenCubit selectedCanteenCubit;

  late CanteenBloc canteenBloc;
  bool isLoading = false;

  List<Canteen> canteens = [];
  final List<Canteen> _fetchedCanteens = [];
  final List<Canteen> _cachedCanteens = [];

  @override
  void initState() {
    super.initState();
    selectedCanteenCubit = context.read<SelectedCanteenCubit>();
  }

  // void loadCanteen() async {
  //   Canteen? canteen;
  //   final prefs = await SharedPreferences.getInstance();
  //   final enumName = prefs.getString("selected-canteen");
  //   try {
  //     canteen =
  //         widget.canteens.firstWhere((element) => element.enumName == enumName);
  //   } catch (e) {
  //     try {
  //       canteen = widget.canteens
  //           .firstWhere((element) => element.enumName == "MENSA_LOTHSTR");
  //     } catch (e) {
  //       canteen = null;
  //     }
  //   }
  //
  //   selectedCanteenCubit.setCanteen(canteen);
  // }
  //
  void saveCanteen(Canteen? canteen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected-canteen", canteen?.enumName ?? "");
  }

  // BlocConsumer<CanteenBloc, CanteenState>(
  //             listener: (context, state) {
  //               if (state is CanteensError) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(state.error),
  //                     duration: const Duration(seconds: 5),
  //                   ),
  //                 );
  //               } else if (state is CanteensFetched) {
  //                 _fetchedCanteens.addAll(state.canteens);
  //                 canteens = _fetchedCanteens;
  //               } else if (state is CanteensFetchedFromCache) {
  //                 isLoading = false;
  //                 _cachedCanteens.addAll(state.canteens);
  //                 canteens = _cachedCanteens;
  //               }
  //             },
  //             builder: (context, state) => CanteenPicker(canteens: canteens),
  //           )

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CanteenBloc>(
      create: (context) {
        canteenBloc = CanteenBloc(
          apiCanteen: ApiCanteen(),
          cacheService: CacheCanteenService(),
        );
        canteenBloc.add(FetchCanteens());
        isLoading = true;
        return canteenBloc;
      },
      child: BlocConsumer<CanteenBloc, CanteenState>(
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
        builder: (context, state) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<Canteen>(
              isExpanded: true,
              onChanged: (canteen) {
                context.read<SelectedCanteenCubit>().setCanteen(canteen);
                saveCanteen(canteen);
              },
              value: context.watch<SelectedCanteenCubit>().state,
              items: canteens
                  .map((canteen) => DropdownMenuItem(
                        value: canteen,
                        child: Text(canteen.name),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
