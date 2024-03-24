import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/kino/detail_view/movie_detail_screen.dart';
import 'package:better_hm/home/dashboard/sections/kino/kino_service.dart';
import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:blurhash_ffi/blurhash_ffi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
              // TODO
              return const _MoviesPlaceholder();
            } else if (!snapshot.hasData) {
              return const Text("no data");
            }

            final movies = snapshot.data!.$2;
            movies.sort((a, b) {
              int cmp = a.date.compareTo(b.date);
              if (cmp != 0) return cmp;
              return a.showTimes.first.compareTo(b.showTimes.first);
            });
            // final firstAfterToday = movies.firstWhere(
            //   (e) => e.date.isAfter(DateTime.now()),
            //   orElse: () => movies.first,
            // );

            final startIndex = movies.lastIndexWhere(
                  (element) => element.date.isBefore(DateTime.now()),
                ) +
                1;

            return ScrollablePositionedList.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              initialScrollIndex: startIndex,
              itemBuilder: (context, index) =>
                  MovieCard(movie: movies[index], movies: movies),
            );
          },
        ),
      ),
    );
  }
}

class _MoviesPlaceholder extends StatelessWidget {
  const _MoviesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Row();
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final List<Movie> movies;

  const MovieCard({super.key, required this.movie, required this.movies});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: EdgeInsets.zero,
      width: 125,
      onTap: () {
        context.pushNamed(
          MovieDetailPage.routeName,
          extra: (movies, movies.indexOf(movie)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: movie,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: AspectRatio(
                aspectRatio: 4 / 6,
                child: MovieImage(movie),
              ),
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

class MovieImage extends StatelessWidget {
  final Movie movie;

  const MovieImage(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: movie.coverUrl,
      placeholder: (context, url) => BlurhashFfi(hash: movie.coverBlurhash),
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => _ErrorWidget(movie),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final Movie movie;

  const _ErrorWidget(this.movie);

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: context.theme.colorScheme.primary,
    //     ),
    //     padding: const EdgeInsets.all(8),
    //     child: Icon(
    //       Icons.error,
    //       color: context.theme.colorScheme.onPrimary,
    //     ),
    //   ),
    // );
    return Stack(
      children: [
        BlurhashFfi(hash: movie.coverBlurhash),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colorScheme.primary,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.error,
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
