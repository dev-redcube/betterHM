import 'package:better_hm/shared/models/location.dart';
import 'package:flutter_test/flutter_test.dart';

const json = {
  "address": "Test Address",
  "latitude": 1.3,
  "longitude": 2.4,
};

void main() {
  test("fromJson", () {
    final location = Location.fromJson(json);
    expect(location, isA<Location>());
  });
}
