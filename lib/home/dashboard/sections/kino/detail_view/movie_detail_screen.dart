import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redcube_campus/home/dashboard/sections/kino/kino_section.dart';
import 'package:redcube_campus/home/dashboard/sections/kino/movie.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/shared/extensions/extensions_context.dart';
import 'package:redcube_campus/shared/extensions/extensions_date_time.dart';

class MovieDetailsScreen extends StatefulWidget {
  final List<Movie> movies;
  final int initialMovie;

  const MovieDetailsScreen({
    super.key,
    required this.movies,
    required this.initialMovie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late final PageController _pageController;
  final _scrollController = TrackingScrollController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialMovie);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children:
          widget.movies
              .map(
                (e) => MovieDetailPage(
                  movie: e,
                  scrollController: _scrollController,
                ),
              )
              .toList(),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  static const routeName = "movie";
  final Movie movie;
  final ScrollController scrollController;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.scrollController,
  });

  Widget hero(Movie movie) => Hero(
    tag: movie,
    child: AspectRatio(
      aspectRatio: 4 / 6,
      child: MovieImage(movie, isBig: true),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 700) {
            return Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: min(
                      constraints.maxWidth / 2,
                      constraints.maxHeight / 6 * 4,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: hero(movie),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: _MovieInformation(movie: movie),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.85,
                  ),
                  child: hero(movie),
                ),
                _MovieInformation(movie: movie),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MovieInformation extends StatelessWidget {
  const _MovieInformation({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            movie.title,
            style: context.theme.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _MovieQuickInfos(movie: movie),
          if (movie.content != null) const SizedBox(height: 32),
          if (movie.content != null) _DescriptionText(movie.content!),
          if (movie.info != null) const SizedBox(height: 24),
          if (movie.info != null) _DescriptionText(movie.info!),
        ],
      ),
    );
  }
}

class _MovieQuickInfos extends StatelessWidget {
  final Movie movie;

  const _MovieQuickInfos({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _IconWithText(
              icon: Icons.today_rounded,
              text: movie.date.formatdMonthAbbr,
            ),
            if (movie.room != null)
              _IconWithText(icon: Icons.location_on_rounded, text: movie.room!),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _IconWithText(icon: Icons.access_time_rounded, text: movie.time),
            _IconWithText(
              icon: Icons.hourglass_top_rounded,
              text: t.dashboard.sections.kino.movie.length(
                minutes: movie.length,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconWithText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class _DescriptionText extends StatelessWidget {
  final String text;

  const _DescriptionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.theme.textTheme.bodyLarge?.copyWith(
        color: context.theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }
}
