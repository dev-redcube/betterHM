import 'dart:async';
import 'dart:convert';

import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:better_hm/home/dashboard/sections/kino/detail_view/movie_detail_screen.dart';
import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:blurhash_ffi/blurhash_ffi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

part 'kino_section.g.dart';

@riverpod
Future<List<Movie>> movies(Ref ref) async {
  final log = Logger("MoviesProvider");
  final uri = Uri(
    scheme: "https",
    host: "api.betterhm.app",
    path: "/v1/movies",
  );
  final client = http.Client();
  final response = await client.get(uri);
  if (200 == response.statusCode) {
    log.info("Successfully fetched movies");
    final movies = Movies.fromJson(jsonDecode(response.body)).movies;
    return movies;
  }
  log.warning(
    "Failed to load movies. Movies API returned ${response.statusCode}",
    response.body,
  );
  throw Exception("Failed to load movies");
}

class KinoSection extends ConsumerWidget {
  const KinoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesProvider);

    Widget errorWidget(Object error, StackTrace stackTrace) {
      Logger("MoviesProvider")
          .severe("Failed to load movies", error, stackTrace);
      return const Text("Couldn't load");
    }

    return DashboardSection(
      title: t.dashboard.sections.kino.title,
      height: 300,
      child: Expanded(
        child: Builder(
          builder: (context) {
            return switch (movies) {
              AsyncData(:final value) => _MoviesRow(movies: value),
              AsyncError(:final error, :final stackTrace) =>
                errorWidget(error, stackTrace),
              _ => const _MoviesPlaceholder(),
            };
          },
        ),
      ),
    );
  }
}

class _MoviesRow extends StatelessWidget {
  const _MoviesRow({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    movies.sort((a, b) {
      int cmp = a.date.compareTo(b.date);
      if (cmp != 0) return cmp;
      return a.time.compareTo(b.time);
    });

    final startIndex = movies.indexWhereOrNull(
          (element) => element.date >= DateTime.now().withoutTime,
        ) ??
        0;

    return ScrollablePositionedList.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      initialScrollIndex: startIndex,
      itemBuilder: (context, index) =>
          MovieCard(movie: movies[index], movies: movies),
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

  String _dateString(Movie movie) {
    final today = DateTime.now();
    if (movie.date.sameDayAs(today))
      return t.general.date.today;
    else if (movie.date.sameDayAs(today.add(const Duration(days: 1))))
      return t.general.date.tomorrow;

    return movie.date.formatdMonthAbbr;
  }

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
                Text(_dateString(movie)),
                Text(movie.time),
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
  final bool isBig;

  const MovieImage(this.movie, {super.key, this.isBig = false});

  @override
  Widget build(BuildContext context) {
    final inPast = movie.date.isBefore(DateTime.now().withoutTime);

    if (movie.coverUrl != null && movie.coverBlurhash != null) {
      return CachedNetworkImage(
        imageUrl: movie.coverUrl!,
        placeholder: (context, url) => BlurhashFfi(hash: movie.coverBlurhash!),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => _ErrorWidget(movie),
        colorBlendMode: inPast && !isBig ? BlendMode.saturation : null,
        color: inPast && !isBig ? Colors.grey : null,
      );
    }
    return Center(
      child: Text(t.dashboard.sections.kino.movie.noImage),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final Movie movie;

  const _ErrorWidget(this.movie);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (movie.coverBlurhash != null)
          BlurhashFfi(hash: movie.coverBlurhash!),
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
