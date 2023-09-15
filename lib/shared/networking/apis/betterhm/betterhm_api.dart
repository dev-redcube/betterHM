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
      BetterHmServiceCalendar _ => "${path}dates-api/thisSemester/split.json",
    };
  }

  @override
  Map<String, String> get parameters => {};
}
