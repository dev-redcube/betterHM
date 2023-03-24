import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_app/cubits/cubit_cantine.dart';
import 'package:hm_app/extensions/extensions_context.dart';
import 'package:hm_app/models/meal/canteen.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<CanteenCubit>().setCanteen(widget.canteens.where((element) => element.enumName == "MENSA_LOTHSTR").first);
  }
  @override
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
        child: DropdownButton<Canteen>(
          isExpanded: true,
          onChanged: (value) {
            context.read<CanteenCubit>().setCanteen(value!);
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
