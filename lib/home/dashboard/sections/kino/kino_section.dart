import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/kino/detail_view/movie_detail_screen.dart';
import 'package:better_hm/home/dashboard/sections/kino/kino_service.dart';
import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:go_router/go_router.dart';

class KinoSection extends StatelessWidget {
  const KinoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: t.dashboard.sections.kino.title,
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

            final movies = snapshot.data!.$2;
            movies.sort((a, b) => a.date.compareTo(b.date));
            final firstAfterToday = movies.firstWhere(
              (e) => e.date.isAfter(DateTime.now()),
              orElse: () => movies.first,
            );

            return ListView(
              scrollDirection: Axis.horizontal,
              children: movies.map((e) => MovieCard(movie: e)).toList(),
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: EdgeInsets.zero,
      width: 125,
      onTap: () {
        context.pushNamed(
          MovieDetailScreen.routeName,
          extra: movie,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AspectRation 4/6
          Hero(
            tag: movie,
            child: AspectRatio(
              aspectRatio: 4 / 6,
              child: movie.coverBlurhash != null
                  ? BlurHash(hash: movie.coverBlurhash!)
                  : const Placeholder(),
              // child: Placeholder(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(movie.date.formatdMonthAbbr),
                Text(movie.showTimes.join(" & ")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
