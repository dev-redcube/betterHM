import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/kino/kino_service.dart';
import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("loading");
              } else if (!snapshot.hasData) {
                return const Text("no data");
              }

              return ListView(
                scrollDirection: Axis.horizontal,
                children:
                    snapshot.data!.$2.map((e) => MovieCard(movie: e)).toList(),
              );
            }),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      padding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 4 / 6,
        child: Placeholder(),
        // child: CachedNetworkImage(
        //   imageUrl: movie.coverUrl,
        // ),
      ),
    );
  }
}
