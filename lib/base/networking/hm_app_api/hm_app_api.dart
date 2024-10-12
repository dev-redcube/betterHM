import 'package:better_hm/base/networking/api.dart';
import 'package:better_hm/base/networking/hm_app_api/hm_app_api_service.dart';

class HmAppApi extends Api {
  final HmAppApiService hmAppApiService;

  HmAppApi(this.hmAppApiService);

  @override
  String get baseURL => "betterhm.huber.cloud";

  @override
  String get paths => switch (hmAppApiService) {
        HmAppApiServiceMovies _ => "/movies",
      };
}
