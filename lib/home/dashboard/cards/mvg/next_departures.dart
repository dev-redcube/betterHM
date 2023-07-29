import 'dart:async';
import 'dart:ui';

import 'package:better_hm/home/dashboard/cards/mvg/departure.dart';
import 'package:better_hm/home/dashboard/cards/mvg/next_departures_card.dart';
import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

import 'line_icon.dart';

// https://stackoverflow.com/questions/53128438/android-onresume-method-equivalent-in-flutter
class NextDepartures extends StatefulWidget {
  const NextDepartures({
    super.key,
    required this.departures,
    required this.config,
  });

  final List<Departure> departures;
  final NextDeparturesConfig config;

  @override
  State<NextDepartures> createState() => _NextDeparturesState();
}

class _NextDeparturesState extends State<NextDepartures>
    with WidgetsBindingObserver {
  late final List<Departure> departures;

  @override
  void initState() {
    super.initState();

    departures = widget.departures.toList();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Departure> filterPastDepartures(List<Departure> departures) {
    final now = DateTime.now();
    return departures
        .where((element) => element.realtimeDepartureTime
            .isAfter(now.add(Duration(minutes: widget.config.offset))))
        .toList();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        departures = filterPastDepartures(departures);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filterPastDepartures(departures);
    final sorted = filtered
      ..sort(
          (a, b) => a.realtimeDepartureTime.compareTo(b.realtimeDepartureTime));

    final items = sorted.take(5).toList();
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.config.station.name,
              style: context.theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          items.isEmpty
              ? Center(
                  child: Text(t.dashboard.cards.nextDepartures
                      .noDepartures(minutes: 30)))
              : ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final departure = items[index];
                    return ListTile(
                      key: ValueKey(departure),
                      leading: LineIcon(departure.label),
                      title: Text(departure.destination),
                      contentPadding: EdgeInsets.zero,
                      dense: false,
                      visualDensity: const VisualDensity(vertical: -4),
                      trailing: DepartureTimer(
                        departure: departure,
                        offset: widget.config.offset,
                        onDone: () {
                          setState(() {
                            departures.remove(departure);
                          });
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class DepartureTimer extends StatefulWidget {
  const DepartureTimer({
    super.key,
    required this.departure,
    this.onDone,
    required this.offset,
  });

  final Departure departure;
  final Null Function()? onDone;
  final int offset;

  @override
  State<DepartureTimer> createState() => _DepartureTimerState();
}

class _DepartureTimerState extends State<DepartureTimer> {
  late Timer _timer;

  late Duration _remaining;

  void startTimer() {
    const d = Duration(seconds: 1);
    _timer = Timer.periodic(d, (timer) {
      if (_remaining.inSeconds <= widget.offset * 60) {
        setState(() {
          timer.cancel();
        });
        widget.onDone?.call();
      } else {
        setState(() {
          _remaining -= d;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _remaining = widget.departure.realtimeDepartureTime.difference(now());
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${_remaining.inMinutes}:${(_remaining.inSeconds % 60).toString().padLeft(2, "0")}",
      style: const TextStyle(
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}
