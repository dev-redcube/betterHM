import 'package:better_hm/shared/networking/api.dart';

import 'eat_api_service.dart';

class EatApi extends Api {
  final EatApiService eatApiService;

  EatApi(this.eatApiService);

  @override
  String get baseUrl => "tum-dev.github.io";

  @override
  String get path => "/eat-api/";

  @override
  String get paths {
    return switch (eatApiService) {
      EatApiServiceCanteens _ => "${path}enums/canteens.json",
      EatApiServiceLanguages _ => "${path}enums/languages.json",
      EatApiServiceLabels _ => "${path}enums/labels.json",
      EatApiServiceAll _ => "${path}all.json",
      EatApiServiceAllRef _ => "${path}all_ref.json",
      EatApiServiceMenu menu =>
        "$path${menu.location}/${menu.year}/${menu.week.toString().padLeft(1, "0")}.json"
    };
  }

  @override
  Map<String, String> get parameters => {};
}
