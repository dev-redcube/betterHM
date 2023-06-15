import 'dart:async';
import 'dart:ui';

import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/mvg/departure.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/53128438/android-onresume-method-equivalent-in-flutter
class NextDepartures extends StatelessWidget {
  const NextDepartures({super.key, required this.departures});

  final List<Departure> departures;

  @override
  Widget build(BuildContext context) {
    final sorted = departures
      ..sort((a, b) => (a.departureLive ?? a.departurePlanned)
          .compareTo(b.departureLive ?? b.departurePlanned));
    final items = sorted.take(5).toList();
    return DashboardCardWidget(
      child: ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final departure = items[index];
          if (departure.departureLive != null || departure.error != null) {
            return ListTile(
              leading: Text(departure.line.number),
              title: Text(departure.direction),
              contentPadding: EdgeInsets.zero,
              dense: false,
              visualDensity: const VisualDensity(vertical: -4),
              trailing: DepartureTimer(departure: departure),
            );
          }
          // no departure time and no error, don't display this row
          return null;
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
