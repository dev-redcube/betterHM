import 'package:better_hm/home/dashboard/cards/mvg/departure.dart';
import 'package:better_hm/shared/exceptions/illegal_arguments_exception.dart';
import 'package:flutter_test/flutter_test.dart';

const json = {
  "plannedDepartureTime": 1690398900000,
  "realtime": true,
  "delayInMinutes": 1,
  "realtimeDepartureTime": 1690398960000,
  "transportType": "TRAM",
  "label": "16",
  "network": "swm",
  "trainType": "",
  "destination": "Effnerplatz",
  "cancelled": false,
  "sev": false,
  "messages": [],
  "bannerHash": "",
  "occupancy": "LOW",
  "stopPointGlobalId": "de:09162:79:2:PDI 2",
};
const minimalJson = {
  "plannedDepartureTime": 1690398900000,
  "realtimeDepartureTime": 1690398960000,
  "transportType": "TRAM",
  "label": "16",
  "network": "swm",
  "destination": "Effnerplatz",
  "occupancy": "LOW",
  "stopPointGlobalId": "de:09162:79:2:PDI 2",
};

void main() {
  test("fromJson with all fields", () {
    final departure = Departure.fromJson(json);
    expect(departure, isA<Departure>());
  });

  test("fromJson with minimal fields", () {
    final departure = Departure.fromJson(minimalJson);
    expect(departure, isA<Departure>());
  });

  test("fromJson without any fields throws", () {
    expect(() => Departure.fromJson({}),
        throwsA(isA<IllegalArgumentsException>()));
  });
}
