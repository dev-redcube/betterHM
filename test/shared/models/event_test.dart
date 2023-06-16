import 'package:better_hm/shared/models/event.dart';
import 'package:flutter_test/flutter_test.dart';

import 'location_test.dart' as location show json;

const json = {
  "title": "Test Title",
  "description": "Test Description",
  "start": "2021-01-01T00:00:00.000Z",
  "end": "2021-01-01T00:00:00.000Z",
  "location": location.json,
};

void main() {
  test("fromJson", () {
    final event = Event.fromJson(json);
    expect(event, isA<Event>());

    final json2 = {
      "title": "Test Title",
      "start": "2021-01-01T00:00:00.000Z",
    };
    final event2 = Event.fromJson(json2);
    expect(event2, isA<Event>());
  });
}
