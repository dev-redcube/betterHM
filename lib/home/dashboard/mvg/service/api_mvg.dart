import 'dart:convert';
import 'package:better_hm/home/dashboard/mvg/departure.dart';
import 'package:better_hm/shared/exceptions/api/api_exception.dart';
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

  Future<List<Departure>> getDepartures(
      {required String stopId, required List<String> lineIds}) async {
    assert(lineIds.isNotEmpty, "Specify at least one lineId");

    // const r = '{"error":"","departures":[{"line":{"number":"20","symbol":"02020.svg","direction":"MoosachBf.","stateless":"swm:02020:G:R:013","name":"Tram"},"direction":"MoosachBf.","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:21","departureLive":"10:21","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"HochschuleMünchen","stateless":"swm:02029:G:H:013","name":"Tram"},"direction":"HochschuleMünchen","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:23","departureLive":"10:23","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"Willibaldplatz","stateless":"swm:02029:G:R:013","name":"Tram"},"direction":"Willibaldplatz","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:24","departureLive":"10:24","inTime":true,"notifications":[]},{"line":{"number":"21","symbol":"02021.svg","direction":"Westfriedhof","stateless":"swm:02021:G:R:013","name":"Tram"},"direction":"Westfriedhof","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:25","departureLive":"10:25","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"21","symbol":"02021.svg","direction":"St.-Veit-Straße","stateless":"swm:02021:G:H:013","name":"Tram"},"direction":"St.-Veit-Straße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:26","departureLive":"10:26","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"153","symbol":"03153.svg","direction":"OdeonsplatzU","stateless":"swm:03153:G:H:013","name":"Bus"},"direction":"OdeonsplatzU","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:27","departureLive":"10:27","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"Karlsplatz(Stachus)","stateless":"swm:02020:G:H:013","name":"Tram"},"direction":"Karlsplatz(Stachus)","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:30","departureLive":"10:30","inTime":true,"notifications":[]},{"line":{"number":"153","symbol":"03153.svg","direction":"Trappentreustraße","stateless":"swm:03153:G:R:013","name":"Bus"},"direction":"Trappentreustraße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:31","departureLive":"10:31","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"MoosachBf.","stateless":"swm:02020:G:R:013","name":"Tram"},"direction":"MoosachBf.","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:31","departureLive":"10:32","inTime":false,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"HochschuleMünchen","stateless":"swm:02029:G:H:013","name":"Tram"},"direction":"HochschuleMünchen","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:33","departureLive":"10:33","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"Willibaldplatz","stateless":"swm:02029:G:R:013","name":"Tram"},"direction":"Willibaldplatz","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:34","departureLive":"10:34","inTime":true,"notifications":[]},{"line":{"number":"21","symbol":"02021.svg","direction":"Westfriedhof","stateless":"swm:02021:G:R:013","name":"Tram"},"direction":"Westfriedhof","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:35","departureLive":"10:32","inTime":false,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"21","symbol":"02021.svg","direction":"St.-Veit-Straße","stateless":"swm:02021:G:H:013","name":"Tram"},"direction":"St.-Veit-Straße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:36","departureLive":"10:36","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"153","symbol":"03153.svg","direction":"OdeonsplatzU","stateless":"swm:03153:G:H:013","name":"Bus"},"direction":"OdeonsplatzU","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:37","departureLive":"10:37","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"Karlsplatz(Stachus)","stateless":"swm:02020:G:H:013","name":"Tram"},"direction":"Karlsplatz(Stachus)","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:40","departureLive":"10:40","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"MoosachBf.","stateless":"swm:02020:G:R:013","name":"Tram"},"direction":"MoosachBf.","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:41","departureLive":"10:41","inTime":true,"notifications":[]},{"line":{"number":"153","symbol":"03153.svg","direction":"Trappentreustraße","stateless":"swm:03153:G:R:013","name":"Bus"},"direction":"Trappentreustraße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:41","departureLive":"10:41","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"HochschuleMünchen","stateless":"swm:02029:G:H:013","name":"Tram"},"direction":"HochschuleMünchen","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:43","departureLive":"10:43","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"Willibaldplatz","stateless":"swm:02029:G:R:013","name":"Tram"},"direction":"Willibaldplatz","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:44","departureLive":"10:44","inTime":true,"notifications":[]},{"line":{"number":"21","symbol":"02021.svg","direction":"Westfriedhof","stateless":"swm:02021:G:R:013","name":"Tram"},"direction":"Westfriedhof","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:45","departureLive":"10:45","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"21","symbol":"02021.svg","direction":"St.-Veit-Straße","stateless":"swm:02021:G:H:013","name":"Tram"},"direction":"St.-Veit-Straße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:46","departureLive":"10:46","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"153","symbol":"03153.svg","direction":"OdeonsplatzU","stateless":"swm:03153:G:H:013","name":"Bus"},"direction":"OdeonsplatzU","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:47","departureLive":"10:47","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"Karlsplatz(Stachus)","stateless":"swm:02020:G:H:013","name":"Tram"},"direction":"Karlsplatz(Stachus)","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:50","departureLive":"10:50","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"MoosachBf.","stateless":"swm:02020:G:R:013","name":"Tram"},"direction":"MoosachBf.","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:51","departureLive":"10:51","inTime":true,"notifications":[]},{"line":{"number":"153","symbol":"03153.svg","direction":"Trappentreustraße","stateless":"swm:03153:G:R:013","name":"Bus"},"direction":"Trappentreustraße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:51","departureLive":"10:51","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"HochschuleMünchen","stateless":"swm:02029:G:H:013","name":"Tram"},"direction":"HochschuleMünchen","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:53","departureLive":"10:53","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"Willibaldplatz","stateless":"swm:02029:G:R:013","name":"Tram"},"direction":"Willibaldplatz","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:54","departureLive":"10:54","inTime":true,"notifications":[]},{"line":{"number":"21","symbol":"02021.svg","direction":"Westfriedhof","stateless":"swm:02021:G:R:013","name":"Tram"},"direction":"Westfriedhof","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:55","departureLive":"10:55","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"21","symbol":"02021.svg","direction":"St.-Veit-Straße","stateless":"swm:02021:G:H:013","name":"Tram"},"direction":"St.-Veit-Straße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:56","departureLive":"10:56","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"153","symbol":"03153.svg","direction":"OdeonsplatzU","stateless":"swm:03153:G:H:013","name":"Bus"},"direction":"OdeonsplatzU","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"10:57","departureLive":"10:57","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"Karlsplatz(Stachus)","stateless":"swm:02020:G:H:013","name":"Tram"},"direction":"Karlsplatz(Stachus)","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:00","departureLive":"11:00","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"MoosachBf.","stateless":"swm:02020:G:R:013","name":"Tram"},"direction":"MoosachBf.","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:01","departureLive":"11:01","inTime":true,"notifications":[]},{"line":{"number":"153","symbol":"03153.svg","direction":"Trappentreustraße","stateless":"swm:03153:G:R:013","name":"Bus"},"direction":"Trappentreustraße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:01","departureLive":"11:01","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"HochschuleMünchen","stateless":"swm:02029:G:H:013","name":"Tram"},"direction":"HochschuleMünchen","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:03","departureLive":"11:03","inTime":true,"notifications":[]},{"line":{"number":"29","symbol":"22029.svg","direction":"Willibaldplatz","stateless":"swm:02029:G:R:013","name":"Tram"},"direction":"Willibaldplatz","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:04","departureLive":"11:04","inTime":true,"notifications":[]},{"line":{"number":"21","symbol":"02021.svg","direction":"Westfriedhof","stateless":"swm:02021:G:R:013","name":"Tram"},"direction":"Westfriedhof","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:05","departureLive":"11:05","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"21","symbol":"02021.svg","direction":"St.-Veit-Straße","stateless":"swm:02021:G:H:013","name":"Tram"},"direction":"St.-Veit-Straße","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:06","departureLive":"11:06","inTime":true,"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]},{"line":{"number":"153","symbol":"03153.svg","direction":"OdeonsplatzU","stateless":"swm:03153:G:H:013","name":"Bus"},"direction":"OdeonsplatzU","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:07","departureLive":"11:07","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"Karlsplatz(Stachus)","stateless":"swm:02020:G:H:013","name":"Tram"},"direction":"Karlsplatz(Stachus)","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:10","departureLive":"11:10","inTime":true,"notifications":[]},{"line":{"number":"20","symbol":"02020.svg","direction":"MoosachBf.","stateless":"swm:02020:G:R:013","name":"Tram"},"direction":"MoosachBf.","station":{"id":"91000012","name":"HochschuleMünchen(Lothstr.)"},"track":"","departureDate":"20230606","departurePlanned":"11:11","departureLive":"11:11","inTime":true,"notifications":[]}],"notifications":[{"text":"Tram21/N19:UmleitungzwischenMax-Weber-PlatzundHaidenauplatz(22.05.-11.06.2023)","link":"https://www.mvg.de/api/ems/tickers/file/1484ddb0-ef5c-43ca-8e7b-fde50bb90546_-1326653268.jpg","type":"line"}]}';
    // final json = jsonDecode(r);
    // List<dynamic> departures = json["departures"];
    // final List<Departure> departuresParsed =
    // departures.map((e) => Departure.fromJson(e)).toList();
    // return departuresParsed;

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

    final response = await http.get(uri);
    if (200 == response.statusCode) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> departures = json["departures"];
      final List<Departure> departuresParsed =
          departures.map((e) => Departure.fromJson(e)).toList();
      return departuresParsed;
    }
    throw ApiException(response: response);
  }
}
