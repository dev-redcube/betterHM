import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/mvg/departure.dart';
import 'package:better_hm/home/dashboard/sections/mvg/mvg_service.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'line_icon.dart';

class Departures extends StatefulWidget {
  final Station station;

  const Departures({super.key, required this.station});

  @override
  State<Departures> createState() => _DeparturesState();
}

class _DeparturesState extends State<Departures> with WidgetsBindingObserver {
  DateTime lastRender = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // If user reopens the app, refresh departures
    if (state == AppLifecycleState.resumed &&
        mounted &&
        DateTime.now().difference(lastRender).inSeconds > 30) {
      setState(() {
        lastRender = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Departure>>(
      future: MvgService().getDepartures(station: widget.station),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const DeparturesListShimmer();
        } else if (!snapshot.hasData) {
          if (snapshot.hasError) {
            Logger("MvgSection").severe(snapshot.error);
          }
          return Center(
            child: Text(
              t.dashboard.sections.mvg.error(station: widget.station.name),
            ),
          );
        }

        /// return departures
        return DeparturesList(
          departures: snapshot.data!,
          refresh: () {
            setState(() {});
          },
        );
      },
    );
  }
}

class DeparturesListShimmer extends StatelessWidget {
  const DeparturesListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144.5,
      child: DashboardSectionShimmer(
        child: ListView.separated(
          itemCount: 5,
          separatorBuilder: (__, _) => const SizedBox(height: 8),
          itemBuilder: (__, _) => SizedBox(
            height: 22.5,
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: Random().nextDouble() * (0.7 - 0.4) + 0.4,
                      // widthFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeparturesList extends StatefulWidget {
  final List<Departure> departures;
  final void Function() refresh;

  const DeparturesList({
    super.key,
    required this.departures,
    required this.refresh,
  });

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
      (a, b) => a.realtimeDepartureTime.compareTo(b.realtimeDepartureTime),
    );
    _departures = departuresTemp.take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144.5,
      child: ListView.separated(
        itemCount: _departures.length,
        itemBuilder: (context, index) {
          final e = _departures.elementAt(index);
          return SizedBox(
            height: 22.5,
            child: Row(
              key: ValueKey(e),
              children: [
                LineIcon(e.label),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(e.destination),
                  ),
                ),
                DepartureTimer(
                  departure: e,
                  onDone: () {
                    // if (_departures.length <= 8) {
                    //   widget.refresh.call();
                    //   return;
                    // }
                    setState(() {
                      _departures.remove(e);
                    });
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (__, _) => const SizedBox(height: 8),
      ),
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
  late int remaining;

  @override
  void initState() {
    super.initState();
    remaining =
        widget.departure.realtimeDepartureTime.difference(now()).inMinutes;
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
      if (remaining < 0) {
        timer.cancel();
        widget.onDone?.call();
      } else {
        setState(() {
          remaining -= d.inMinutes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${remaining < 0 ? 0 : remaining} min",
      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
    );
  }
}
