import 'package:better_hm/home/dashboard/cards/mvg/station.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = {
    "id": "de:09162:12",
    "name": "Linie 21",
  };

  test("fromJson", () {
    final station = Station.fromJson(json);
    expect(station, isA<Station>());
    expect(station.toJson(), json);
  });

  test("toJson", () {
    final station = Station(id: "de:09162:12", name: "Linie 21");
    expect(station.toJson(), json);
  });
}
