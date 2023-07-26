// ignore_for_file: file_names

import 'package:better_hm/shared/prefs.dart';

/// For version 1.1
/// Migrate cards to the new format
Future<void> migration2() async {
  await Prefs.cards.waitUntilLoaded();
  List<String> cardsConfig = Prefs.cards.value;
  Prefs.cards.value =
      cardsConfig.map((e) => e.replaceAll("leadTime", "offset")).toList();
}
