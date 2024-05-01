import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/home/meals/service/selected_canteen_wrapper.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
import 'package:better_hm/shared/components/select_sheet_button.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class CanteenPicker extends ConsumerWidget {
  const CanteenPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCanteen = ref.watch(selectedCanteenProvider);

    switch (selectedCanteen) {
      case AsyncData(:final value):
        return _CanteenPickerButton(canteenWrapper: value);
      case AsyncError():
        return const Text("Error loading");
      case _:
        return const SizedBox.shrink();
    }
  }
}

class _CanteenPickerButton extends ConsumerWidget {
  const _CanteenPickerButton({required this.canteenWrapper});

  final SelectedCanteenWrapper canteenWrapper;

  LiveLocationState get locationState {
    if (canteenWrapper.hasError) return LiveLocationState.error;

    if (canteenWrapper.canteen == null) return LiveLocationState.searching;

    return canteenWrapper.isAutomatic
        ? LiveLocationState.found
        : LiveLocationState.off;
  }

  String get _text {
    if (!canteenWrapper.isAutomatic) {
      return canteenWrapper.canteen?.name ?? "Unknown";
    }
    return canteenWrapper.canteen?.name ?? "Searching";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectSheetButton<Canteen>(
      locationState: locationState,
      text: _text,
      itemsBuilder: () async {
        final canteens = await ref.read(canteensProvider.future);

        final permission = getIt<LocationService>().permission;
        final deniedForever = permission == LocationPermission.deniedForever;

        return [
          SelectBottomSheetItem(
            title: deniedForever
                ? t.mealplan.selector.automatic.disabledText
                : t.mealplan.selector.automatic.title,
            subtitle: deniedForever
                ? null
                : t.mealplan.selector.automatic.description,
            enabled: !deniedForever,
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
              SelectedCanteenWrapper(
                isAutomatic: isAutomatic,
                canteen: item.data,
              ),
            );
      },
    );
  }
}
