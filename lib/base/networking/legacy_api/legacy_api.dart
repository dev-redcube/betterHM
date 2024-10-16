import 'package:better_hm/base/networking/api.dart';
import 'package:better_hm/base/networking/legacy_api/legacy_api_service.dart';

class LegacyHmAppApi extends Api {
  final LegacyHmAppApiService hmAppApiService;

  LegacyHmAppApi(this.hmAppApiService);

  @override
  String get baseURL => "betterhm.huber.cloud";

  @override
  String get paths => switch (hmAppApiService) {
        LegacyHmAppApiServiceMovies _ => "/movies",
      };
}
