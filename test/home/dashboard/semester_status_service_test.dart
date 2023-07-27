import 'package:better_hm/home/dashboard/cards/semester_status/models/semester_event.dart';
import 'package:better_hm/home/dashboard/cards/semester_status/semester_status_service.dart';
import 'package:better_hm/shared/exceptions/api/api_exception.dart';
import 'package:better_hm/shared/exceptions/parsing_exception.dart';
import 'package:better_hm/shared/service/http_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mvg/mvg_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test("fetching Events with valid data", () async {
    final client = MockClient();
    bool calledUrl = false;

    when(client.get(Uri.parse(SemesterStatusService.url))).thenAnswer(
      (_) async {
        calledUrl = true;
        return http.Response(
          """{"semester_type": "Sommersemester 2023","events": [{"title": "Dauer des Semesters","dates": [{"start": "2023-03-15T00:00:00","end": "2023-09-30T23:59:59"}],"tag": "duration_of_semester"},{"title": "Vorlesungszeit","dates": [{"start": "2023-03-15T00:00:00","end": "2023-07-07T23:59:59"}],"tag": "lecture_period"},{"title": "Vorlesungsfreie Zeit","dates": [{"start": "2023-04-06T00:00:00","end": "2023-04-11T23:59:59"},{"start": "2023-05-26T00:00:00","end": "2023-05-30T23:59:59"},{"start": "2023-07-08T00:00:00","end": "2023-09-30T23:59:59"}],"tag": "lecture_free_time"},{"title": "Pr\u00fcfungsanmeldung","dates": [{"start": "2023-04-26T00:00:00","end": "2023-05-05T23:59:59"}],"tag": "exam_registration"},{"title": "Pr\u00fcfungszeitraum","dates": [{"start": "2023-07-08T00:00:00","end": null}],"tag": "exam_period_start"},{"title": "Notenbekanntgabe","dates": [{"start": "2023-07-28T00:00:00","end": null}],"tag": "grades_release"},{"title": "R\u00fcckmeldung","dates": [{"start": "2023-07-03T00:00:00","end": "2023-07-31T23:59:59"}],"tag": "re-registration_for_next_semester"},{"title": "Belegung Online-Los-Durchgang I","dates": [{"start": "2023-03-08T00:00:00","end": "2023-03-15T23:59:59"}],"tag": "1-st_AW_subject_draw_lot"},{"title": "Ergebnisse 1. Losdurchgang (nur online)","dates": [{"start": "2023-03-16T00:00:00","end": null}],"tag": null},{"title": "Belegung Online Losdurchgang II (ganzt\u00e4gig)","dates": [{"start": "2023-03-16T00:00:00","end": null},{"start": "2023-03-17T00:00:00","end": null}],"tag": "2-st_AW_subject_draw_lot"},{"title": "Ergebnisse 2. Losdurchgang (nur online)","dates": [{"start": "2023-03-20T00:00:00","end": null}],"tag": null},{"title": "Vorlesungsbeginn AW-Lehrveranstaltungen","dates": [{"start": "2023-03-22T00:00:00","end": null}],"tag": "start_of_AW_lectures"}],"time_of_last_update": "2023-07-27T02:01:03.720626","recent_data": true}""",
          200,
          headers: {"content-type": "application/json; charset=utf-8"},
        );
      },
    );

    HttpService().client = client;

    final events = await SemesterStatusService().getEvents();
    expect(events, isA<List<SemesterEvent>>());

    /// Make sure the mockClient was used
    expect(calledUrl, true);
  });

  test("api returns status 500", () async {
    final client = MockClient();
    bool calledUrl = false;
    when(client.get(Uri.parse(SemesterStatusService.url))).thenAnswer(
      (_) async {
        calledUrl = true;
        return http.Response("", 500);
      },
    );

    HttpService().client = client;

    expect(() async {
      await SemesterStatusService().getEvents();
    }, throwsA(isA<ApiException>()));

    /// Make sure the mockClient was used
    expect(calledUrl, true);
  });

  test("api returns status 200 but cannot be parsed", () async {
    final client = MockClient();
    bool calledUrl = false;
    when(client.get(Uri.parse(SemesterStatusService.url))).thenAnswer(
      (_) async {
        calledUrl = true;
        return http.Response("{}", 200);
      },
    );

    HttpService().client = client;

    expect(() async {
      await SemesterStatusService().getEvents();
    }, throwsA(isA<ParsingException>()));

    /// Make sure the mockClient was used
    expect(calledUrl, true);
  });
}
