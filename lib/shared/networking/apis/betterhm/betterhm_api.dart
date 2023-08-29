import 'package:better_hm/shared/networking/api.dart';
import 'package:better_hm/shared/networking/apis/betterhm/betterhm_api_service.dart';

class BetterHmApi extends Api {
  final BetterHmService betterHmService;

  BetterHmApi(this.betterHmService);

  @override
  String get baseUrl => "api.betterhm.app";

  @override
  String get path => "/";

  @override
  get paths {
    return switch (betterHmService) {
      BetterHmServiceDates _ => "${path}dates-api/thisSemester/all.json",
    };
  }

  @override
  Map<String, String> get parameters => {};
}
