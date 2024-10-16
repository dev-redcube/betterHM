
import 'package:better_hm/base/networking/legacy_api/legacy_api.dart';
import 'package:better_hm/base/networking/legacy_api/legacy_api_service.dart';
import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/homeComponent/models/movie.dart';
import 'package:better_hm/main.dart';

class MovieService {
  static Future<({DateTime? saved, List<Movie> data})> fetchMovies(
    bool forcedRefresh,
  ) async {
    final restClient = getIt<RestClient>();
    final response = await restClient.get<Movies, LegacyHmAppApi>(
      LegacyHmAppApi(LegacyHmAppApiServiceMovies()),
      Movies.fromJson,
      forcedRefresh,
    );

    return (saved: response.saved, data: response.data.movies);
  }
}
