import 'package:better_hm/base/networking/eat_api/eat_api.dart';
import 'package:better_hm/base/networking/eat_api/eat_api_service.dart';
import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/canteenComponent/models/canteen.dart';
import 'package:better_hm/main.dart';

class CanteenService {
  static Future<({DateTime? saved, List<Canteen> data})> fetchCanteens([
    bool forcedRefresh = false,
  ]) async {
    RestClient restClient = getIt<RestClient>();

    final response = await restClient.get<Canteens, EatApi>(
      EatApi(EatApiServiceCanteens()),
      Canteens.fromJson,
      forcedRefresh,
    );

    return (saved: response.saved, data: response.data.canteens);
  }
}
