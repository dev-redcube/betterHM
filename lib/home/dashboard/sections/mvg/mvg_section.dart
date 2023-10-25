import 'dart:async';

import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/mvg/departures.dart';
import 'package:better_hm/home/dashboard/sections/mvg/station_provider.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MvgSection extends StatelessWidget {
  const MvgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationProvider(),
      child: DashboardSection(
        title: t.dashboard.sections.mvg.title,
        right: const SelectStationWidget(),
        child: DashboardCard(
          child: Consumer<StationProvider>(
            builder: (context, provider, child) =>
                Departures(station: provider.station),
          ),
        ),
      ),
    );
  }
}

class SelectStationWidget extends StatefulWidget {
  const SelectStationWidget({super.key});

  @override
  State<SelectStationWidget> createState() => _SelectStationWidgetState();
}

class _SelectStationWidgetState extends State<SelectStationWidget> {
  showStationSelector(BuildContext context) {
    final provider = Provider.of<StationProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (context) => ChangeNotifierProvider.value(
          value: provider, child: const StationBottomSheet()),
    );
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
          // const LiveLocationIndicator(updating: true),
          Consumer<StationProvider>(
            builder: (context, provider, child) {
              return Text(
                provider.station.name,
                overflow: TextOverflow.clip,
              );
            },
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down_rounded),
        ],
      ),
    );
  }
}

class LiveLocationIndicator extends StatefulWidget {
  final bool updating;

  const LiveLocationIndicator({
    super.key,
    required this.updating,
  });

  @override
  State<LiveLocationIndicator> createState() => _LiveLocationIndicatorState();
}

class _LiveLocationIndicatorState extends State<LiveLocationIndicator> {
  late bool _updating;
  bool currentStatus = false;
  late Timer timer;

  final duration = const Duration(milliseconds: 750);

  @override
  void initState() {
    super.initState();
    _updating = widget.updating;

    if (_updating) {
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
    if (oldWidget.updating != widget.updating) {
      _updating = widget.updating;
      if (_updating) {
        timer = Timer.periodic(duration, timerFunc);
      } else {
        timer.cancel();
      }
    }
  }

  void timerFunc(Timer timer) {
    setState(() {
      currentStatus = !currentStatus;
    });
  }

  IconData get icon {
    if (!_updating) return Icons.my_location_rounded;

    return currentStatus
        ? Icons.my_location_rounded
        : Icons.location_searching_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Icon(icon, size: 16),
    );
  }
}

class StationBottomSheet extends StatelessWidget {
  const StationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: stations
          .map(
            (e) => ListTile(
              leading: Icon(e.icon),
              title: Text(e.name),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () {
                Provider.of<StationProvider>(context, listen: false).station =
                    e;
                Prefs.selectedMvgStation.value = e.id;
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
    );
  }
}
