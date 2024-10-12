import 'package:json_annotation/json_annotation.dart';

part "movie.g.dart";

@JsonSerializable(createToJson: false)
class Movies {
  @JsonKey(name: "data")
  final List<Movie> movies;

  Movies(this.movies);

  factory Movies.fromJson(Map<String, dynamic> json) => _$MoviesFromJson(json);
}

@JsonSerializable(createToJson: false)
class Movie {
  final String title;
  final DateTime date;
  final String time;
  final String? fsk;
  final String? genre;
  final int length;
  final String? info;
  final String? content;
  final String? room;
  final String? coverUrl;
  final String? coverBlurhash;
  final String? unifilmUrl;

  Movie({
    required this.title,
    required this.date,
    required this.time,
    this.fsk,
    this.genre,
    required this.length,
    this.info,
    this.content,
    this.room,
    this.coverUrl,
    this.coverBlurhash,
    this.unifilmUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
