import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:logging/logging.dart';

class KinoService {
  final Logger _log = Logger("KinoService");

  Future<(DateTime?, List<Movie>)> getMovies() async {
    _log.info("Getting movies");

    final uri = Uri(
      scheme: "https",
      host: "betterhm.huber.cloud",
      path: "/movies",
    );

    final mainApi = getIt<MainApi>();

    final response = await mainApi.get<Movies>(uri, Movies.fromJson);

    return (response.saved, response.data.movies);
  }
}
