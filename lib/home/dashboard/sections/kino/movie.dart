import 'package:json_annotation/json_annotation.dart';

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
  @JsonKey(name: "times")
  final List<String> showTimes;
  final String fsk;
  final String genre;
  final int length;
  final String info;
  final String content;
  final String room;
  final String coverUrl;
  final String coverBlurhash;
  final String unifilmUrl;

  Movie({
    required this.title,
    required this.date,
    required this.showTimes,
    required this.fsk,
    required this.genre,
    required this.length,
    required this.info,
    required this.content,
    required this.room,
    required this.coverUrl,
    required this.coverBlurhash,
    required this.unifilmUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return _$MovieFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
