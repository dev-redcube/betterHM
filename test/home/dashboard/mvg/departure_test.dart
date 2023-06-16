import 'package:better_hm/home/dashboard/mvg/departure.dart';
import 'package:flutter_test/flutter_test.dart';

const json = {
  "line": {
    "stateless": "123",
    "number": "123",
    "direction": "123",
  },
  "direction": "Hauptbahnhof",
  "station": {
    "id": "de:09162:12",
    "name": "Linie 21",
  },
  "departureDate": "20230616",
  "departurePlanned": "12:34",
  "departureLive": "12:34",
  "inTime": true,
};

void main() {
  test("fromJson with all fields", () {
    final departure = Departure.fromJson(json);
    expect(departure, isA<Departure>());
  });

  test("fromJson with departureLive error", () {
    final j = Map<String, dynamic>.from(json);
    j["departureLive"] = "entfällt";
    final departure = Departure.fromJson(j);
    expect(departure, isA<Departure>());
    expect(departure.error, isNotNull);
    expect(departure.departureLive, isNull);
  });
}
