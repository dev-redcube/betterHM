import 'package:better_hm/shared/logger/logger.dart';
import 'package:isar/isar.dart';

part 'log_entry.g.dart';

@Collection(accessor: "logEntries")
class LogEntry {
  final id = Isar.autoIncrement;
  final DateTime timestamp;

  @enumerated
  final LogLevel level;
  final String message;
  final String? tag;

  LogEntry(this.level, this.message, this.tag) : timestamp = DateTime.now();
}
