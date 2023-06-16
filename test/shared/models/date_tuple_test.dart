import 'package:better_hm/shared/models/date_tuple.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("fromJson", () {
    final json = {
      "start": "2023-06-16T05:15",
      "end": "2023-06-16T05:16",
    };
    final t1 = DateTuple.fromJson(json);
    expect(t1, isA<DateTuple>());
    json.remove("end");
    final t2 = DateTuple.fromJson(json);
    expect(t2, isA<DateTuple>());
  });
}
