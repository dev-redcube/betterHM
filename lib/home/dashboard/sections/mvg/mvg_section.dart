import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/mvg/departures.dart';
import 'package:better_hm/home/dashboard/sections/mvg/station_provider.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
import 'package:better_hm/shared/components/select_sheet_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MvgSection extends StatelessWidget {
  const MvgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: t.dashboard.sections.mvg.title,
      right: const _StationPicker(),
      child: const _DeparturesConsumerWrapper(),
    );
  }
}

class _StationPicker extends ConsumerWidget {
  const _StationPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStation = ref.watch(selectedStationProvider);

    switch (selectedStation) {
      case AsyncData(:final value):
        return _StationPickerButton(stationWrapper: value);
      case AsyncError():
        return const Text("Error loading");
      case _:
        return const SizedBox.shrink();
    }
  }
}

class _StationPickerButton extends ConsumerWidget {
  const _StationPickerButton({required this.stationWrapper});

  final SelectedStationWrapper stationWrapper;

  LiveLocationState get locationState {
    if (stationWrapper.station == null) return LiveLocationState.searching;

    return stationWrapper.isAutomatic
        ? LiveLocationState.found
        : LiveLocationState.off;
  }

  String get _text {
    if (!stationWrapper.isAutomatic) {
      return stationWrapper.station?.name ?? "Unknown";
    }
    return stationWrapper.station?.name ?? "Searching";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectSheetButton<Station>(
      locationState: locationState,
      text: _text,
      items: [
        SelectBottomSheetItem(
          title: "AUTOMATIC",
          icon: Icons.my_location_rounded,
        ),
        ...stations.map(
          (e) => SelectBottomSheetItem(
            title: e.name,
            data: e,
          ),
        ),
      ],
      onSelect: (item) {
        final isAutomatic = item.data == null;
        ref.read(selectedStationProvider.notifier).set(
              SelectedStationWrapper(
                isAutomatic: isAutomatic,
                station: item.data,
              ),
            );
      },
    );
  }
}

class _DeparturesConsumerWrapper extends ConsumerWidget {
  const _DeparturesConsumerWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStation = ref.watch(selectedStationProvider);

    switch (selectedStation) {
      case AsyncData(:final value):
        return DashboardCard(
          child: value.station == null
              ? const DeparturesListShimmer()
              : Departures(
                  key: ObjectKey(value.station),
                  station: value.station!,
                ),
        );
      case AsyncError():
        return const Text("Error loading");
      case _:
        return const SizedBox.shrink();
    }
  }
}
