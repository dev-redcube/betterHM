import 'dart:async';
import 'dart:ui';

import 'package:better_hm/home/dashboard/cards/mvg/departure.dart';
import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/53128438/android-onresume-method-equivalent-in-flutter
class NextDepartures extends StatefulWidget {
  const NextDepartures({super.key, required this.departures});

  final List<Departure> departures;

  @override
  State<NextDepartures> createState() => _NextDeparturesState();
}

class _NextDeparturesState extends State<NextDepartures>
    with WidgetsBindingObserver {
  late final List<Departure> departures;

  @override
  void initState() {
    super.initState();

    departures = widget.departures
        .where((element) => element.departureLive != null)
        .toList();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = departures
      ..sort((a, b) => a.departureLive!.compareTo(b.departureLive!));

    final items = sorted.take(5).toList();
    return DashboardCard(
      child: items.isEmpty
          ? Center(
              child: Text(
                  t.dashboard.cards.nextDepartures.noDepartures(minutes: 30)))
          : ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final departure = items[index];
                return ListTile(
                  key: ValueKey(departure),
                  leading: Text(departure.line.number),
                  title: Text(departure.direction),
                  contentPadding: EdgeInsets.zero,
                  dense: false,
                  visualDensity: const VisualDensity(vertical: -4),
                  trailing: DepartureTimer(
                    departure: departure,
                    onDone: () {
                      setState(() {
                        departures.remove(departure);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

class DepartureTimer extends StatefulWidget {
  const DepartureTimer({
    super.key,
    required this.departure,
    this.onDone,
  });

  final Departure departure;
  final Null Function()? onDone;

  @override
  State<DepartureTimer> createState() => _DepartureTimerState();
}

class _DepartureTimerState extends State<DepartureTimer> {
  late Timer _timer;

  late Duration _remaining;

  void startTimer() {
    const d = Duration(seconds: 1);
    _timer = Timer.periodic(d, (timer) {
      if (_remaining.inSeconds == 0) {
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
    if (widget.departure.departureLive != null) {
      _remaining = widget.departure.departureLive!.difference(now());
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.departure.departureLive != null) {
      return Text(
        "${_remaining.inMinutes}:${(_remaining.inSeconds % 60).toString().padLeft(2, "0")}",
        style: const TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      );
    }
    return Text(widget.departure.error!);
  }
}
