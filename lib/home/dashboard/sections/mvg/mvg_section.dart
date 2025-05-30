import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:redcube_campus/home/dashboard/dashboard_card.dart';
import 'package:redcube_campus/home/dashboard/dashboard_section.dart';
import 'package:redcube_campus/home/dashboard/sections/mvg/departures.dart';
import 'package:redcube_campus/home/dashboard/sections/mvg/selected_station_wrapper.dart';
import 'package:redcube_campus/home/dashboard/sections/mvg/stations.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/main.dart';
import 'package:redcube_campus/shared/components/live_location_indicator.dart';
import 'package:redcube_campus/shared/components/select_sheet_button.dart';
import 'package:redcube_campus/shared/service/location_service.dart';

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
      case AsyncError(:final error):
        Logger(
          "_StationPicker",
        ).severe("Error while getting selected Station", error);
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
    if (stationWrapper.hasError) return LiveLocationState.error;

    if (stationWrapper.station == null) return LiveLocationState.searching;

    return stationWrapper.isAutomatic
        ? LiveLocationState.found
        : LiveLocationState.off;
  }

  String get _text {
    if (!stationWrapper.isAutomatic) {
      return stationWrapper.station?.name ?? "Unknown";
    }
    return stationWrapper.station?.name ??
        t.dashboard.sections.mvg.selector.searching;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectSheetButton<Station>(
      locationState: locationState,
      text: _text,
      itemsBuilder: () async {
        final permission = getIt<LocationService>().permission;
        final deniedForever = permission == LocationPermission.deniedForever;
        return [
          SelectBottomSheetItem(
            title:
                deniedForever
                    ? t.dashboard.sections.mvg.selector.automatic.disabledText
                    : t.dashboard.sections.mvg.selector.automatic.title,
            subtitle:
                deniedForever
                    ? null
                    : t.dashboard.sections.mvg.selector.automatic.description,
            enabled: !deniedForever,
            icon: Icons.my_location_rounded,
          ),
          ...stations.map(
            (e) => SelectBottomSheetItem(
              title: e.name,
              subtitle: e.campus,
              icon: e.icon,
              data: e,
            ),
          ),
        ];
      },
      onSelect: (item) {
        final isAutomatic = item.data == null;
        ref
            .read(selectedStationProvider.notifier)
            .set(
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
          child:
              value.station == null
                  ? const DeparturesListShimmer()
                  : Departures(
                    key: ObjectKey(value.station),
                    station: value.station!,
                  ),
        );
      case AsyncError(:final error):
        Logger(
          "_DeparturesConsumerWrapper",
        ).severe("Error while getting selected Station", error);
        return const Text("Error loading");
      case _:
        return const SizedBox.shrink();
    }
  }
}
