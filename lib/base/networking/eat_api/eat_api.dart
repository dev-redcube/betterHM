import 'package:better_hm/base/networking/api.dart';
import 'package:better_hm/base/networking/eat_api/eat_api_service.dart';

class EatApi extends Api {
  final EatApiService eatApiService;

  EatApi(this.eatApiService);

  @override
  String get baseURL => "tum-dev.github.io";

  @override
  String get path => "/eat-api";

  @override
  String get paths => switch (eatApiService) {
      EatApiServiceCanteens _ => "$path/enums/canteens.json",
      EatApiServiceCombinedMenu combined => "$path/${combined.canteen.canteenId}/combined/combined.json"
    };
}
