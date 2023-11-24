import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/mvg/departures.dart';
import 'package:better_hm/home/dashboard/sections/mvg/select_station.dart';
import 'package:better_hm/home/dashboard/sections/mvg/station_provider.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class MvgSection extends StatelessWidget {
  const MvgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationProvider(),
      child: const _MvgContent(),
    );
  }
}

class _MvgContent extends StatefulWidget {
  const _MvgContent();

  @override
  State<_MvgContent> createState() => _MvgContentState();
}

class _MvgContentState extends State<_MvgContent> {
  StationProvider? provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider ??= Provider.of<StationProvider>(context);
    provider!.addListener(stationConfigChanged);
    updateLocation();
  }

  void stationConfigChanged() {
    updateLocation();
  }

  void updateLocation() async {
    if (!Prefs.autoMvgStation.value ||
        provider!.state.locationState != StationLocationState.searching) {
      return;
    }

    Logger("MvgSection").info("Updating Location");

    Station? nearest = await StationService.getNearestStation();

    if (nearest != null) {
      provider!.state = StationState(nearest, StationLocationState.found);
      Prefs.lastMvgStation.value = nearest.id;
    } else {
      provider!.state = StationState(
        provider!.state.station,
        StationLocationState.error,
      );
    }
  }

  @override
  void dispose() {
    provider!.removeListener(stationConfigChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: t.dashboard.sections.mvg.title,
      right: const SelectStationWidget(),
      child: DashboardCard(
        child: Consumer<StationProvider>(
          builder: (context, provider, child) => Departures(
            key: ObjectKey(provider.state.station),
            station: provider.state.station,
          ),
        ),
      ),
    );
  }
}
