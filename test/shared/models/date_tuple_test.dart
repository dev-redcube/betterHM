import 'package:better_hm/shared/extensions/extensions_date_time.dart';
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
  test("isAroundToday", () {
    final d = DateTuple(
      today().subtract(const Duration(days: 1)),
      tomorrow(),
    );
    expect(d.isAroundToday(), true);

    final d2 = DateTuple(today(), tomorrow());
    expect(d2.isAroundToday(), false);
  });
}
