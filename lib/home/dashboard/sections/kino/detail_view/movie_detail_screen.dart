import 'package:better_hm/home/dashboard/sections/kino/kino_section.dart';
import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  static const routeName = "movie";
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: movie,
              child: AspectRatio(
                aspectRatio: 4 / 6,
                child: MovieImage(movie),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    movie.title,
                    style: context.theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  _MovieDetails(movie: movie),
                  const SizedBox(height: 32),
                  _DescriptionText(movie.content),
                  const SizedBox(height: 24),
                  _DescriptionText(movie.info),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

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
            _IconWithText(
              icon: Icons.location_on_rounded,
              text: movie.room,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _IconWithText(
              icon: Icons.access_time_rounded,
              text: movie.showTimes.join(" & "),
            ),
            _IconWithText(
              icon: Icons.hourglass_top_rounded,
              text:
                  t.dashboard.sections.kino.movie.length(minutes: movie.length),
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
