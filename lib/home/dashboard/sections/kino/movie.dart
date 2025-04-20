import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movies {
  @JsonKey(name: "data")
  final List<Movie> movies;

  Movies({required this.movies});

  factory Movies.fromJson(Map<String, dynamic> json) => _$MoviesFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesToJson(this);
}

@JsonSerializable()
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

  factory Movie.fromJson(Map<String, dynamic> json) {
    try {
      return _$MovieFromJson(json);
    } catch (e) {
      Logger(
        "Movie",
      ).severe("Failed to parse movie $json", e, StackTrace.current);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
