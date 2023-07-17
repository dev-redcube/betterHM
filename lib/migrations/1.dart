import 'package:shared_preferences/shared_preferences.dart';

/// For version 1.1
/// Migrate cards to the new format
Future<void> migration1() async {
  final prefs = await SharedPreferences.getInstance();

  /// remove the old card, because it is not compatible with the new format
  await prefs.remove("cards");
}
