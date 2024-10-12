import 'package:better_hm/base/networking/hm_app_api/hm_app_api.dart';
import 'package:better_hm/base/networking/hm_app_api/hm_app_api_service.dart';
import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/homeComponent/models/movie.dart';
import 'package:better_hm/main.dart';

class MovieService {
  static Future<({DateTime? saved, List<Movie> data})> fetchMovies(
    bool forcedRefresh,
  ) async {
    final restClient = getIt<RestClient>();
    final response = await restClient.get<Movies, HmAppApi>(
      HmAppApi(HmAppApiServiceMovies()),
      Movies.fromJson,
      forcedRefresh,
    );

    return (saved: response.saved, data: response.data.movies);
  }
}
