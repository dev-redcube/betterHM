import 'package:better_hm/home/dashboard/cards/mvg/departure.dart';
import 'package:better_hm/home/dashboard/cards/mvg/service/mvg_service.dart';
import 'package:better_hm/home/dashboard/cards/mvg/transport_type.dart';
import 'package:better_hm/shared/exceptions/api/api_exception.dart';
import 'package:better_hm/shared/exceptions/parsing_exception.dart';
import 'package:better_hm/shared/service/http_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mvg_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test("fetching Departures with valid data", () async {
    final client = MockClient();
    bool calledUrl = false;
    when(client.get(Uri.parse(
            "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:79&limit=20&offsetInMinutes=1&transportTypes=UBAHN,TRAM,BUS,SBAHN,SCHIFF")))
        .thenAnswer((_) async {
      calledUrl = true;
      return http.Response(
          """[{"plannedDepartureTime":1690398900000,"realtime":true,"delayInMinutes":1,"realtimeDepartureTime":1690398960000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690399200000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690399200000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690399500000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690399500000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690399800000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690399800000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690400100000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690400100000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690400400000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690400400000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690400700000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690400700000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690401000000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690401000000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690401300000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690401300000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690401600000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690401600000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690401900000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690401900000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690402140000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690402140000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Karlsplatz (Stachus)","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690402500000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690402500000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690403160000,"realtime":false,"realtimeDepartureTime":1690403160000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690403400000,"realtime":true,"delayInMinutes":0,"realtimeDepartureTime":1690403400000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690404360000,"realtime":false,"realtimeDepartureTime":1690404360000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690404600000,"realtime":false,"realtimeDepartureTime":1690404600000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690405560000,"realtime":false,"realtimeDepartureTime":1690405560000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"},{"plannedDepartureTime":1690405800000,"realtime":false,"realtimeDepartureTime":1690405800000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Effnerplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 2"},{"plannedDepartureTime":1690406760000,"realtime":false,"realtimeDepartureTime":1690406760000,"transportType":"TRAM","label":"16","network":"swm","trainType":"","destination":"Romanplatz","cancelled":false,"sev":false,"messages":[],"bannerHash":"","occupancy":"LOW","stopPointGlobalId":"de:09162:79:2:PDI 1"}]""",
          200);
    });

    HttpService().client = client;

    final departures = await MvgService().getDepartures(
        stationId: "de:09162:79", transportTypes: TransportType.values);
    expect(departures, isA<List<Departure>>());

    /// Make sure the mockClient was used
    expect(calledUrl, true);
  });

  test("api returns status 500", () async {
    final client = MockClient();
    bool calledUrl = false;
    when(client.get(Uri.parse(
            "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:79&limit=20&offsetInMinutes=1&transportTypes=UBAHN,TRAM,BUS,SBAHN,SCHIFF")))
        .thenAnswer((_) async {
      calledUrl = true;
      return http.Response("", 500);
    });

    HttpService().client = client;

    expect(() async {
      await MvgService().getDepartures(
          stationId: "de:09162:79", transportTypes: TransportType.values);
    }, throwsA(isA<ApiException>()));

    /// Make sure the mockClient was used
    expect(calledUrl, true);
  });

  test("api returns status 200 but cannot be parsed", () async {
    final client = MockClient();
    bool calledUrl = false;
    when(client.get(Uri.parse(
            "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:79&limit=20&offsetInMinutes=1&transportTypes=UBAHN,TRAM,BUS,SBAHN,SCHIFF")))
        .thenAnswer((_) async {
      calledUrl = true;
      return http.Response("{}", 200);
    });

    HttpService().client = client;

    expect(() async {
      await MvgService().getDepartures(
          stationId: "de:09162:79", transportTypes: TransportType.values);
    }, throwsA(isA<ParsingException>()));

    /// Make sure the mockClient was used
    expect(calledUrl, true);
  });
}
