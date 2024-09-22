import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(">", () {
    final first = DateTime(2024, 09, 22);
    final second = DateTime(2024, 09, 23);

    expect(second > first, true);
    expect(first > second, false);
    expect(first > first, false);
  });

  test(">=", () {
    final first = DateTime(2024, 09, 22);
    final second = DateTime(2024, 09, 23);

    expect(second >= first, true);
    expect(first >= second, false);
    expect(first >= first, true);
  });

  test(">", () {
    final first = DateTime(2024, 09, 22);
    final second = DateTime(2024, 09, 23);

    expect(second < first, false);
    expect(first < second, true);
    expect(first < first, false);
  });

  test(">=", () {
    final first = DateTime(2024, 09, 22);
    final second = DateTime(2024, 09, 23);

    expect(second <= first, false);
    expect(first <= second, true);
    expect(first <= first, true);
  });
}
