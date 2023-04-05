import 'package:better_hm/cubits/selected_canteen_cubit.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenPicker extends StatefulWidget {
  const CanteenPicker({
    super.key,
    required this.canteens,
  });

  final List<Canteen> canteens;

  @override
  State<CanteenPicker> createState() => _CanteenPickerState();
}

class _CanteenPickerState extends State<CanteenPicker> {
  late final SelectedCanteenCubit selectedCanteenCubit;

  @override
  void initState() {
    super.initState();
    selectedCanteenCubit = context.read<SelectedCanteenCubit>();
  }

  void saveCanteen(Canteen? canteen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected-canteen", canteen?.enumName ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Canteen>(
        isExpanded: true,
        onChanged: (canteen) {
          context.read<SelectedCanteenCubit>().setCanteen(canteen);
          saveCanteen(canteen);
        },
        value: context.watch<SelectedCanteenCubit>().state,
        items: widget.canteens
            .map((canteen) => DropdownMenuItem(
                  value: canteen,
                  child: Text(canteen.name),
                ))
            .toList(),
      ),
    );
  }
}
