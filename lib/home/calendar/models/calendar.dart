import 'package:flutter/painting.dart';
import 'package:isar/isar.dart';

part 'calendar.g.dart';

@collection
class Calendar {
  Id? id;
  String? externalId;

  String name;
  String url;
  int? colorValue;

  bool isActive;

  /// For now, the local calendar can not be deleted, just deactivated
  bool isLocal;

  int numOfFails;
  DateTime? lastUpdate;

  Calendar({
    this.id,
    this.externalId,
    required this.name,
    required this.url,
    this.isActive = true,
    this.numOfFails = 0,
    this.isLocal = false,
    Color? color,
  }) : colorValue = color?.toARGB32();

  @ignore
  Color? get color => colorValue == null ? null : Color(colorValue!);

  set color(Color? color) => colorValue = color?.toARGB32();

  @override
  String toString() =>
      "Calendar(id: $id, externalId: $externalId, name: $name, url: $url, color: $color, $isActive, numOfFails: $numOfFails, lastUpdate: $lastUpdate)";
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
