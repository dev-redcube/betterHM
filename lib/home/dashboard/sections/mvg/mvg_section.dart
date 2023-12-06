import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/mvg/departures.dart';
import 'package:better_hm/home/dashboard/sections/mvg/select_station.dart';
import 'package:better_hm/home/dashboard/sections/mvg/station_provider.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class MvgSection extends StatelessWidget {
  const MvgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchingStateProvider(),
      child: ChangeNotifierProvider(
        create: (_) => StationProvider(),
        child: const _MvgContent(),
      ),
    );
  }
}

class _MvgContent extends StatefulWidget {
  const _MvgContent();

  @override
  State<_MvgContent> createState() => _MvgContentState();
}

class _MvgContentState extends State<_MvgContent> {
  StationProvider? stationProvider;
  SearchingStateProvider? searchingStateProvider;

  Logger log = Logger("MvgSection");

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    stationProvider ??= Provider.of<StationProvider>(context);
    stationProvider!.addListener(stationConfigChanged);
    searchingStateProvider ??= Provider.of<SearchingStateProvider>(context);
    updateLocation();
  }

  void stationConfigChanged() {
    updateLocation();
  }

  void updateLocation() async {
    if (stationProvider!.station != null ||
        searchingStateProvider!.state == StationLocationState.error) {
      return;
    }

    if (searchingStateProvider!.state != StationLocationState.searching) {
      searchingStateProvider!.state = StationLocationState.searching;
    }

    log.fine("Updating Location");

    Station? nearest = await StationService.getNearestStation().timeout(
      const Duration(seconds: 10),
      onTimeout: () => Future.value(null),
    );

    if (nearest != null) {
      stationProvider!.station = nearest;
      searchingStateProvider!.state = StationLocationState.found;
      log.fine("Found nearest Station ${nearest.name}");
    } else {
      log.warning("Could not find nearest station");
      searchingStateProvider!.state = StationLocationState.error;
    }
  }

  @override
  void dispose() {
    stationProvider!.removeListener(stationConfigChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: t.dashboard.sections.mvg.title,
      right: const SelectStationWidget(),
      child: DashboardCard(
        child: Consumer<StationProvider>(
          builder: (context, provider, child) {
            if (stationProvider!.station == null) {
              return Consumer<SearchingStateProvider>(
                builder: (context, provider, child) {
                  if (provider.state == StationLocationState.error) {
                    return Center(
                      child: Text(t.dashboard.sections.mvg.positionError),
                    );
                  }
                  return const DeparturesListShimmer();
                },
              );
            }
            return Departures(
              key: ObjectKey(stationProvider!.station),
              station: stationProvider!.station!,
            );
          },
        ),
      ),
    );
  }
}
