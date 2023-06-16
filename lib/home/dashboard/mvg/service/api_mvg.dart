import 'dart:convert';

import 'package:better_hm/home/dashboard/mvg/departure.dart';
import 'package:better_hm/shared/exceptions/api/api_exception.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:http/http.dart' as http;

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
/// 153|Bus (Trappentreustrae) => swm:03153:G:R:013
///
///
/// line svg images are stored in https://www.mvv-muenchen.de/fileadmin/lines/LINE_NUMBER.svg
/// e.g. https://www.mvv-muenchen.de/fileadmin/lines/02020.svg

const stopIdLothstr = "de:09162:12";

const lineIdsLothstr = [
  "swm:02020:G:H:013",
  "swm:02020:G:R:013",
  "swm:02021:G:H:013",
  "swm:02021:G:R:013",
  "swm:02029:G:H:013",
  "swm:02029:G:R:013",
  "swm:02N20:G:H:013",
  "swm:02N20:G:R:013",
  "swm:03153:G:H:013",
  "swm:03153:G:R:013",
];

class ApiMvg {
  static const baseUrl = "www.mvv-muenchen.de";
  static const loggerTag = "mvg service";

  Future<List<Departure>> getDepartures({
    http.Client? client,
    required String stopId,
    required List<String> lineIds,
  }) async {
    assert(lineIds.isNotEmpty, "Specify at least one lineId");
    final logger = Logger(loggerTag);

    logger.info("Fetching departures for stop $stopId");

    client ??= http.Client();

    final linesString =
        lineIds.map((e) => "&line=${Uri.encodeComponent(e)}").join();
    final linesEncoded = base64Encode(utf8.encode(linesString));

    final uri = Uri(scheme: "https", host: baseUrl, queryParameters: {
      "eID": "departuresFinder",
      "action": "get_departures",
      "stop_id": stopId,
      "requested_timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000 +
              const Duration(minutes: 1).inSeconds)
          .toString(),
      "lines": linesEncoded,
    });

    final response = await client.get(uri);
    if (200 == response.statusCode) {
      try {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> departures = json["departures"];
        return parseDepartures(departures);
      } catch (e) {
        logger.error("Error parsing MVG API", response.body);
        throw ApiException(message: "Error parsing MVG API");
      }
    }

    logger.error("API status code is not 200",
        "${response.statusCode}: ${response.body}");
    throw ApiException(response: response);
  }

  List<Departure> parseDepartures(List<dynamic> departures) =>
      departures.map((e) => Departure.fromJson(e)).toList();
}
