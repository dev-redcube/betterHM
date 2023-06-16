import 'package:better_hm/home/dashboard/mvg/station.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("fromJson", () {
    final json = {
      "id": "de:09162:12",
      "name": "Linie 21",
    };
    final station = Station.fromJson(json);
    expect(station, isA<Station>());
  });
}