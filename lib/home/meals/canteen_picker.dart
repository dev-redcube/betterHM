import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
import 'package:better_hm/shared/components/select_sheet_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectSheetButton(
      locationState: canteen.locationState,
      text: canteen.canteen?.name ?? "Searching",
      itemsBuilder: () async {
        final canteens = await ref.read(canteensProvider.future);
        return [
          SelectBottomSheetItem(
            title: "Automatic",
            icon: Icons.my_location_rounded,
          ),
          ...canteens.map(
            (e) => SelectBottomSheetItem(
              title: e.name,
              icon: Icons.restaurant_rounded,
              data: e,
            ),
          ),
        ];
      },
      onSelect: (item) {
        ref.read(selectedCanteenProvider.notifier).set(
              SelectedCanteenProvider(
                locationState: item.data == null
                    ? LiveLocationState.searching
                    : LiveLocationState.off,
                canteen: item.data,
              ),
            );
      },
    );
  }
}
