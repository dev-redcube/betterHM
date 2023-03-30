import 'package:better_hm/cubits/cubit_cantine.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenPicker extends StatefulWidget {
  const CanteenPicker({
    super.key,
    required this.canteens,
    required this.context,
  });

  final List<Canteen> canteens;
  final BuildContext context;

  @override
  State<CanteenPicker> createState() => _CanteenPickerState();
}

class _CanteenPickerState extends State<CanteenPicker> {
  late final CanteenCubit canteenCubit;

  @override
  void initState() {
    super.initState();
    canteenCubit = context.read<CanteenCubit>();
    loadCanteen();
  }

  void loadCanteen() async {
    Canteen? canteen;
    final prefs = await SharedPreferences.getInstance();
    final enumName = prefs.getString("selected-canteen");
    try {
      canteen =
          widget.canteens.firstWhere((element) => element.enumName == enumName);
    } catch (e) {
      try {
        canteen = widget.canteens
            .firstWhere((element) => element.enumName == "MENSA_LOTHSTR");
      } catch (e) {
        canteen = null;
      }
    }

    canteenCubit.setCanteen(canteen);
  }

  void saveCanteen(Canteen? canteen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected-canteen", canteen?.enumName ?? "");
  }

  @override
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
        child: DropdownButton<Canteen>(
          isExpanded: true,
          onChanged: (canteen) {
            context.read<CanteenCubit>().setCanteen(canteen);
            saveCanteen(canteen);
          },
          value: context.watch<CanteenCubit>().state,
          items: widget.canteens
              .map((canteen) => DropdownMenuItem(
                    value: canteen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(canteen.name),
                        if (canteen.location?.address != null)
                          Text(canteen.location!.address!,
                              style: context.theme.textTheme.labelMedium),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
}
