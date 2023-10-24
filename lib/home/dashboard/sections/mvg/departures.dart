import 'package:better_hm/home/dashboard/sections/mvg/mvg_service.dart';
import 'package:better_hm/home/dashboard/sections/mvg/stations.dart';
import 'package:flutter/material.dart';

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
        return const Text("data");
      },
    );
  }
}
