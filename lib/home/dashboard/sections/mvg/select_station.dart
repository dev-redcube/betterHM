import 'package:better_hm/home/dashboard/sections/mvg/station_provider.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/components/live_location_indicator.dart';
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

class StationBottomSheet extends StatelessWidget {
  final bool locationDeniedForever;

  const StationBottomSheet({required this.locationDeniedForever, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
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
            Provider.of<StationProvider>(context, listen: false).station = null;
            Provider.of<SearchingStateProvider>(context, listen: false).state =
                LiveLocationState.searching;
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
                  .state = LiveLocationState.off;
              Prefs.lastMvgStation.value = e.id;
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
