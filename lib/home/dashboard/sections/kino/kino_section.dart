import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/kino/kino_service.dart';
import 'package:flutter/material.dart';

class KinoSection extends StatelessWidget {
  const KinoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: "Kino",
      height: 300,
      child: Expanded(
        child: FutureBuilder(
            future: KinoService().getMovies(),
            builder: (context, snapshot) {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  MovieCard(),
                  MovieCard(),
                  MovieCard(),
                ],
              );
            }),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(child: Text("Hello This is a long movie"));
  }
}
