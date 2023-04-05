import 'package:isar/isar.dart';

abstract class IsarService {
  late Future<Isar> db;

  Future<void> openDB();
}
