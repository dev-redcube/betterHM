import 'package:isar/isar.dart';

part 'calendar.g.dart';

@collection
class Calendar {
  String id;

  Id get isarId => fastHash(id);
  bool isActive;
  int numOfFails;
  String name;
  String url;

  Calendar({
    required this.id,
    required this.isActive,
    required this.numOfFails,
    required this.name,
    required this.url,
  });
}

/// FNV-1a 64bit Hash-Algorithmus optimiert für Dart-Strings
/// https://isar.dev/de/recipes/string_ids.html
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
