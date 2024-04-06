import 'dart:async';
import 'dart:io';

import 'package:better_hm/home/dashboard/sections/mvg/station_provider.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SelectStationWidget extends StatefulWidget {
  const SelectStationWidget({super.key});

  @override
  State<SelectStationWidget> createState() => _SelectStationWidgetState();
}

class _SelectStationWidgetState extends State<SelectStationWidget> {
  void showStationSelector(BuildContext context) {
    final stationProvider =
        Provider.of<StationProvider>(context, listen: false);
    final searchingStateProvider = Provider.of<SearchingStateProvider>(
      context,
      listen: false,
    );
    final permission = getIt<LocationService>().permission;
    if (mounted) {
      showModalBottomSheet(
        context: context,
        enableDrag: true,
        showDragHandle: true,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
          value: searchingStateProvider,
          child: ChangeNotifierProvider.value(
            value: stationProvider,
            child: StationBottomSheet(
              locationDeniedForever:
                  permission == LocationPermission.deniedForever,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showStationSelector(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(12, 2, 2, 2),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Row(
        children: [
          Consumer<SearchingStateProvider>(
            builder: (context, provider, child) =>
                LiveLocationIndicator(state: provider.state),
          ),
          Consumer<StationProvider>(
            builder: (context, provider, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.station?.name ??
                        t.dashboard.sections.mvg.selector.searching,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down_rounded),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class LiveLocationIndicator extends StatefulWidget {
  final StationLocationState state;

  const LiveLocationIndicator({
    super.key,
    required this.state,
  });

  @override
  State<LiveLocationIndicator> createState() => _LiveLocationIndicatorState();
}

class _LiveLocationIndicatorState extends State<LiveLocationIndicator> {
  StationLocationState state = StationLocationState.searching;
  late Timer timer;

  final duration = const Duration(milliseconds: 750);

  @override
  void initState() {
    super.initState();
    state = widget.state;

    if (state == StationLocationState.searching) {
      timer = Timer.periodic(duration, timerFunc);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LiveLocationIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      state = widget.state;
      if (state == StationLocationState.searching) {
        timer = Timer.periodic(duration, timerFunc);
      } else {
        timer.cancel();
      }
    }
  }

  void timerFunc(Timer timer) {
    setState(() {
      state = state == StationLocationState.searching
          ? StationLocationState.found
          : StationLocationState.searching;
    });
  }

  IconData? get icon => switch (state) {
        StationLocationState.searching => Icons.location_searching_rounded,
        StationLocationState.found => Icons.my_location_rounded,
        StationLocationState.error => Icons.error_rounded,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(icon, size: 16),
          );
  }
}

class StationBottomSheet extends StatelessWidget {
  final bool locationDeniedForever;

  const StationBottomSheet({required this.locationDeniedForever, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (!Platform.isLinux)
          ListTile(
            leading: const Icon(Icons.my_location_rounded),
            title: Text(t.dashboard.sections.mvg.selector.automatic.title),
            subtitle: Text(
              locationDeniedForever
                  ? t.dashboard.sections.mvg.selector.automatic.disabledText
                  : t.dashboard.sections.mvg.selector.automatic.description,
            ),
            enabled: !locationDeniedForever,
            onTap: () {
              Provider.of<StationProvider>(context, listen: false).station =
                  null;
              Provider.of<SearchingStateProvider>(context, listen: false)
                  .state = StationLocationState.searching;
              Prefs.lastMvgStation.value = "";
              Navigator.pop(context);
            },
          ),
        ...stations.map(
          (e) => ListTile(
            leading: Icon(e.icon),
            title: Text(e.name),
            subtitle: e.campus == null ? null : Text(e.campus!),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () {
              Provider.of<StationProvider>(context, listen: false).station = e;
              Provider.of<SearchingStateProvider>(context, listen: false)
                  .state = StationLocationState.manual;
              Prefs.lastMvgStation.value = e.id;
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
