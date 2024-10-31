import 'package:better_hm/base/networking/eat_api/eat_api.dart';
import 'package:better_hm/base/networking/eat_api/eat_api_service.dart';
import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/canteenComponent/models/canteen.dart';
import 'package:better_hm/canteenComponent/models/day.dart';
import 'package:better_hm/main.dart';

class MealplanService {
  static Future<({DateTime? saved, List<MealDay> data})> fetchMeals(
      Canteen canteen, [
        bool forcedRefresh = false,
      ]) async {
    RestClient restClient = getIt<RestClient>();

    final response = await restClient.get<List<MealDay>, EatApi>(
      EatApi(EatApiServiceCombinedMenu(canteen: canteen)),
      MealPlan.parse,
      forcedRefresh,
    );

    return (saved: response.saved, data: response.data);
  }
}
