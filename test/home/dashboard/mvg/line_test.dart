import 'package:better_hm/home/dashboard/mvg/line.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("fromJson with all fields", () {
    final json = {
      "stateless": "swm:02020:G:H:013",
      "number": "21",
      "direction": "Hauptbahnhof",
      "symbol": "U.svg",
      "name": "Linie 21",
    };
    final line = Line.fromJson(json);
    expect(line, isA<Line>());
  });

  test("fromJson without symbol and name", () {
    final json = {
      "stateless": "swm:02020:G:H:013",
      "number": "21",
      "direction": "Hauptbahnhof",
    };
    final line = Line.fromJson(json);
    expect(line, isA<Line>());
  });
}
