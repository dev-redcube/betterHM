import 'package:better_hm/home/meals/models/canteen.dart';
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
        return _CanteenPickerButton(canteenProvider: value);
      case AsyncError():
        return const Text("Error loading");
      case _:
        return const SizedBox.shrink();
    }
  }
}

class _CanteenPickerButton extends ConsumerWidget {
  const _CanteenPickerButton({required this.canteenProvider});

  final SelectedCanteenProvider canteenProvider;

  LiveLocationState get locationState {
    if (canteenProvider.canteen == null) return LiveLocationState.searching;

    return canteenProvider.isAutomatic
        ? LiveLocationState.found
        : LiveLocationState.off;
  }

  String get _text {
    if (!canteenProvider.isAutomatic) {
      return canteenProvider.canteen?.name ?? "Unknown";
    }
    return canteenProvider.canteen?.name ?? "Searching";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectSheetButton<Canteen>(
      locationState: locationState,
      text: _text,
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
              data: e,
            ),
          ),
        ];
      },
      onSelect: (item) {
        final isAutomatic = item.data == null;
        ref.read(selectedCanteenProvider.notifier).set(
              SelectedCanteenProvider(
                isAutomatic: isAutomatic,
                canteen: item.data,
              ),
            );
      },
    );
  }
}
