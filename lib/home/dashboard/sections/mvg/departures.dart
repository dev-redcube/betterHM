import 'dart:async';
import 'dart:ui';

import 'package:better_hm/home/dashboard/sections/mvg/departure.dart';
import 'package:better_hm/home/dashboard/sections/mvg/mvg_service.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

import 'line_icon.dart';

class Departures extends StatelessWidget {
  final Station station;

  const Departures({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MvgService().getDepartures(stationId: station.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading");
        } else if (!snapshot.hasData) {
          return const Text("error");
        }

        /// return departures
        return DeparturesList(departures: snapshot.data!);
      },
    );
  }
}

class DeparturesList extends StatefulWidget {
  final List<Departure> departures;

  const DeparturesList({super.key, required this.departures});

  @override
  State<DeparturesList> createState() => _DeparturesListState();
}

class _DeparturesListState extends State<DeparturesList> {
  late final List<Departure> _departures;

  @override
  void initState() {
    super.initState();
    final departuresTemp = List.of(widget.departures);
    departuresTemp.sort(
        (a, b) => a.realtimeDepartureTime.compareTo(b.realtimeDepartureTime));
    _departures = departuresTemp.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _departures
          .map(
            (e) => ListTile(
              key: ValueKey(e),
              leading: LineIcon(e.label),
              title: Text(e.destination),
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              trailing: DepartureTimer(
                departure: e,
                onDone: () {
                  setState(() {
                    _departures.remove(e);
                  });
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class DepartureTimer extends StatefulWidget {
  final Departure departure;
  final void Function()? onDone;

  const DepartureTimer({super.key, required this.departure, this.onDone});

  @override
  State<DepartureTimer> createState() => _DepartureTimerState();
}

class _DepartureTimerState extends State<DepartureTimer> {
  late Timer timer;
  late Duration remaining;

  @override
  void initState() {
    super.initState();
    remaining = widget.departure.realtimeDepartureTime.difference(now());
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const d = Duration(seconds: 1);
    timer = Timer.periodic(d, (timer) {
      if (remaining.isNegative) {
        timer.cancel();
        widget.onDone?.call();
      } else {
        setState(() {
          remaining -= d;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${remaining.inMinutes} min",
      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
    );
  }
}
