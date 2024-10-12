import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/homeComponent/models/station.dart';
import 'package:better_hm/homeComponent/service/departure_service.dart';
import 'package:better_hm/main.dart';
import 'package:flutter_test/flutter_test.dart';


/// Just for development
/// TODO remove
void main() {
  getIt.registerSingleton(RestClient());

  test("api works", () async {

    final res = await DepartureService.fetchDepartures(stations.first);

    print(res);
  });
}
