import 'dart:convert';

import 'package:better_hm/exceptions/api/api_exception.dart';
import 'package:better_hm/models/dashboard/semester_event.dart';
import 'package:better_hm/services/api/api_service.dart';
import 'package:flutter/foundation.dart';

class ApiSemesterStatus extends ApiService {
  static const url =
      "https://raw.githubusercontent.com/adriangeorgimmel/hm-dates-api/gh-pages/thisSemester/all.json";

  Future<List<SemesterEvent>> getEvents() async {
    if (kDebugMode) {
      print("fetching events");
    }
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
