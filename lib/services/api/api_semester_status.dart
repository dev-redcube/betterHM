import 'dart:convert';

import 'package:better_hm/models/dashboard/semester_event.dart';
import 'package:better_hm/services/api/api_service.dart';

class ApiSemesterStatus extends ApiService {
  static const url =
      "https://raw.githubusercontent.com/adriangeorgimmel/hm-dates-api/gh-pages/thisSemester/all.json";

  Future<List<SemesterEvent>> getEvents() async {
    // await Future.delayed(const Duration(milliseconds: 500));
    final List<dynamic> json = jsonDecode(
        '[{"title":"Lecture Time","tag":"LECTURE_TIME","dates":[{"start":"2023-03-15", "end":"2023-07-07"}]},{"title":"MyEvent2 with a very long title","dates":[{"start":"2023-06-01T13:00","end":"2023-06-02T00:00"},{"start":"2023-06-05T00:00","end":"2023-06-07T00:00"}]},{"title":"The last Event","dates":[{"start":"2023-06-04T00:00"}]}]');
    final events = json.map((e) => SemesterEvent.fromJson(e)).toList();
    return events;

    // remove above

    // final response = await httpGet(url);
    // if (200 == response.statusCode) {
    //   final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
    //   List<SemesterEvent> events =
    //       json.map((e) => SemesterEvent.fromJson(e)).toList();
    //   return events;
    // }
    // throw ApiException(response: response);
  }
}
