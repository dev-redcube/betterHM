import 'dart:convert';

import 'package:better_hm/home/dashboard/cards/mvg/departure.dart';
import 'package:better_hm/home/dashboard/cards/mvg/transport_type.dart';
import 'package:better_hm/shared/exceptions/api/api_exception.dart';
import 'package:better_hm/shared/exceptions/parsing_exception.dart';
import 'package:better_hm/shared/service/http_service.dart';
import 'package:logging/logging.dart';

/// API for MVG
/// example shows all departures from Lothstraße
/// example: https://www.mvv-muenchen.de/?eID=departuresFinder&action=get_departures&stop_id=de%3A09162%3A12&requested_timestamp=1685906480&lines=JmxpbmU9c3dtJTNBMDIwMjAlM0FHJTNBSCUzQTAxMyZsaW5lPXN3bSUzQTAyMDIwJTNBRyUzQVIlM0EwMTMmbGluZT1zd20lM0EwMjAyMSUzQUclM0FIJTNBMDEzJmxpbmU9c3dtJTNBMDIwMjElM0FHJTNBUiUzQTAxMyZsaW5lPXN3bSUzQTAyMDI5JTNBRyUzQUglM0EwMTMmbGluZT1zd20lM0EwMjAyOSUzQUclM0FSJTNBMDEzJmxpbmU9c3dtJTNBMDJOMjAlM0FHJTNBSCUzQTAxMyZsaW5lPXN3bSUzQTAyTjIwJTNBRyUzQVIlM0EwMTMmbGluZT1zd20lM0EwMzE1MyUzQUclM0FIJTNBMDEzJmxpbmU9c3dtJTNBMDMxNTMlM0FHJTNBUiUzQTAxMw%3D%3D
///
/// Breakdown:
/// https://www.mvv-muenchen.de/?eID=departuresFinder // root url
/// &action=get_departures => self-explanatory
/// &stop_id=de%3A09162%3A12 => stop id, decoded: de:09162:12
/// &requested_timestamp=1685906480 => unix timestamp
/// &lines=BASE64 => the interesting part, base64 encoded
///
/// lines base64:
/// &line=swm%3A02020%3AG%3AH%3A013&line=... // encoded, repeats for every line swm:02020:G:H:013
/// breakdown:
/// swm =>
/// 02020 => line number
/// G =>
/// H => can be [H, R], specifies direction
/// 013 =>
///
/// stop ids listed here https://www.mvv-muenchen.de/fileadmin/mediapool/02-Fahrplanauskunft/03-Downloads/openData/MVV_HSTReport2212.csv
/// line ids are not officially documented

/// IDs:
/// Lothstraße: de:09162:12
///
/// Lines:
/// 20|Tram (Stachus) => swm:02020:G:H:013
/// 20|Tram (Moosach) => swm:02020:G:R:013
/// 21|Tram (St. Veitstraße) => swm:02021:G:H:013
/// 21|Tram (Westfriedhof) => swm:02021:G:R:013
/// 29|Tram (Hochschule München) => swm:02029:G:H:013
/// 29|Tram (Willibaldplatz) => swm:02029:G:R:013
/// N20|Bus (Stachus) => swm:02N20:G:H:013
/// N20|Bus (Moosach) => swm:02N20:G:R:013
/// 153|Bus (Universität) => swm:03153:G:H:013
/// 153|Bus (Trappentreustraße) => swm:03153:G:R:013
///
///
/// line svg images are stored in https://www.mvv-muenchen.de/fileadmin/lines/LINE_NUMBER.svg
/// e.g. https://www.mvv-muenchen.de/fileadmin/lines/02020.svg

class MvgService {
  final Logger _log = Logger("MvgService");

  Future<List<Departure>> getDepartures({
    required String stationId,
    int limit = 20,
    required List<TransportType> transportTypes,
    Duration offset = const Duration(minutes: 1),
  }) async {
    assert(transportTypes.isNotEmpty, "Specify at least one transport Type");

    _log.info("Fetching departures for stop $stationId");

    final uri = Uri(
        scheme: "https",
        host: "www.mvg.de",
        path: "api/fib/v2/departure",

        /// cannot use queryParameters because there variables would be encoded
        query:
            "globalId=$stationId&limit=$limit&offsetInMinutes=${offset.inMinutes}&transportTypes=${transportTypes.map((e) => e.name).join(",")}");

    final stopwatch = Stopwatch()..start();
    final response = await HttpService().client.get(uri);
    stopwatch.stop();

    _log.fine("MVG Api call took ${stopwatch.elapsedMilliseconds}ms");
    if (200 == response.statusCode) {
      try {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> departures = json;
        final List<Departure> parsed =
            departures.map((e) => Departure.fromJson(e)).toList();
        return parsed;
      } catch (e, stacktrace) {
        _log.severe(
            "Error parsing MVG API. Please file a bug report", e, stacktrace);
        throw ParsingException(
            "Error parsing MVG API. Please file a bug report");
      }
    }

    _log.warning("MVG Api call failed with status code ${response.statusCode}",
        response.body);
    throw ApiException(
        message: "MVG Api call failed with status code ${response.statusCode}",
        response: response);
  }
}
