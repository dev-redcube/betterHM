import 'package:shared_preferences/shared_preferences.dart';

import '1.dart';
import '2.dart';

/// This array contains all migrations
/// for new migrations, add a new entry to the array, but do not modify old ones
/// Make sure await all changes so no code is run after the method returns.
///
/// Note on Isar: Isar migrates automatically, if you do need to make manual changes,
/// make sure to close the instance after use
const migrations = <Future<void> Function()>[
  migration1,
  migration2,
];

Future<void> runMigrations() async {
  final prefs = await SharedPreferences.getInstance();

  // not saved => Assume that app is newly installed => set to all migrations ran
  final int num = prefs.getInt("migrations") ?? migrations.length;
  final todo = migrations.skip(num);
  for (var element in todo) {
    await element.call();
  }

  // after all migrations ran, update saved value
  await prefs.setInt("migrations", migrations.length);
}
