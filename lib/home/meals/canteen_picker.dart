import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
import 'package:better_hm/shared/components/select_sheet_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenPicker extends ConsumerWidget {
  const CanteenPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCanteen = ref.watch(selectedCanteenProvider);

    switch (selectedCanteen) {
      case AsyncData(:final value):
        return _CanteenPickerButton(canteen: value);
      case AsyncError():
        return const Text("Error loading");
      case _:
        return const SizedBox.shrink();
    }
  }
}

class _CanteenPickerButton extends ConsumerWidget {
  const _CanteenPickerButton({required this.canteen});

  final SelectedCanteenProvider canteen;

  LiveLocationState get locationState {
    if (canteen.canteen == null) return LiveLocationState.searching;

    return canteen.isAutomatic
        ? LiveLocationState.found
        : LiveLocationState.off;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectSheetButton(
      locationState: locationState,
      text: canteen.canteen?.name ?? "Searching",
      itemsBuilder: () async {
        final canteens = await ref.read(canteensProvider.future);
        return canteens.map(
          (e) => SelectBottomSheetItem(
            title: e.name,
            icon: Icons.restaurant_rounded,
            data: e,
          ),
        );
      },
      onSelect: (item) {
        ref.read(selectedCanteenProvider.notifier).set(
              SelectedCanteenProvider(isAutomatic: false, canteen: item.data),
            );
      },
    );
  }
}

void loadDefaultCanteen() async {
  // final provider = Provider.of<SelectedCanteenProvider>(context);
  // final prefs = await SharedPreferences.getInstance();
  // final String? canteenEnum = prefs.getString("selected-canteen");
  // final Canteen canteen = widget.canteens.firstWhere(
  //   (element) => element.enumName == (canteenEnum ?? "MENSA_LOTHSTR"),
  // );
  // provider.canteen = canteen;
}

void saveCanteen(Canteen? canteen) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("selected-canteen", canteen?.enumName ?? "");
}
