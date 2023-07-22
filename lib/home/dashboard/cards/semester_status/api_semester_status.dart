import 'dart:convert';

import 'package:better_hm/shared/exceptions/api/api_exception.dart';
import 'package:better_hm/shared/service/api_service.dart';
import 'package:logging/logging.dart';

import 'models/semester_event.dart';

class ApiSemesterStatus extends ApiService {
  static const url =
      "https://api.betterhm.app/hm-dates-api/thisSemester/all.json";
  final Logger _log = Logger("SemesterStatusService");

  Future<List<SemesterEvent>> getEvents() async {
    _log.info("Fetching Events from Server...");
    final response = await httpGet(url);
    if (200 == response.statusCode) {
      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> eventsJson = json['events'];
      final events = eventsJson.map((e) => SemesterEvent.fromJson(e)).toList();
      return events;
    }
    throw ApiException(response: response);
  }
}
