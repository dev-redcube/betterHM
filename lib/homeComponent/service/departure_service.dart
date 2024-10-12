import 'package:better_hm/base/networking/mvg_api/mvg_api.dart';
import 'package:better_hm/base/networking/rest_client.dart';
import 'package:better_hm/homeComponent/models/departure.dart';
import 'package:better_hm/homeComponent/models/station.dart';
import 'package:better_hm/main.dart';

class DepartureService {
  static Future<List<Departure>> fetchDepartures(
    Station station, [
    Duration? offset,
  ]) async {
    final restClient = getIt<RestClient>();
    final response = await restClient.get<Departures, MvgApi>(
      MvgApi(station: station, offset: offset),
      Departures.fromJson,
      true,
    );
    return response.data.departures;
  }
}
