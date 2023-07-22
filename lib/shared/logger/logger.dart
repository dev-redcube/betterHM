import 'dart:developer';

import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/service/isar_service.dart';
import 'package:isar/isar.dart';

class Logger {
  final String? _tag;

  Logger(String? tag) : _tag = tag?.toUpperCase();

  void debug(String message, [String? extra]) {
    LoggerStatic().debug(_tag, message, extra);
  }

  void d(String message, [String? extra]) => debug(message, extra);

  void info(String message, [String? extra]) {
    LoggerStatic().info(_tag, message, extra);
  }

  void i(String message, [String? extra]) => info(message, extra);

  void warning(String message, [String? extra]) {
    LoggerStatic().warning(_tag, message, extra);
  }

  void w(String message, [String? extra]) => warning(message, extra);

  void error(String message, [String? extra]) {
    LoggerStatic().error(_tag, message, extra);
  }

  void e(String message, [String? extra]) => error(message, extra);
}

class LoggerStatic extends IsarService {
  static final LoggerStatic _instance = LoggerStatic._internal();
  static late final Isar _isar;

  static bool initialized = false;

  LoggerStatic._internal();

  Future<void> init() async {
    if (initialized) {
      return;
    }
    _isar = await db;
    initialized = true;
  }

  factory LoggerStatic() => _instance;

  Stream<List<LogEntry>> stream() => _isar.logEntries
      .where()
      .sortByTimestamp()
      .limit(500)
      .watch(fireImmediately: true);

  Future<List<Map<String, dynamic>>> dump() async {
    return await _isar.logEntries.where().sortByTimestamp().exportJson();
  }

  Future<void> clearLogs() async => await _isar.writeTxn(() => _isar.clear());

  void _write(LogEntry entry) async {
    await _isar.writeTxn(() async {
      _isar.logEntries.put(entry);
    });
    log("${entry.level.name.toUpperCase()}: ${entry.message}");
  }

  void debug(String? tag, String message, String? extra) {
    final entry = LogEntry(LogLevel.debug, message, tag, extra: extra);
    _write(entry);
  }

  void info(String? tag, String message, String? extra) {
    final entry = LogEntry(LogLevel.info, message, tag, extra: extra);
    _write(entry);
  }

  void warning(String? tag, String message, String? extra) {
    final entry = LogEntry(LogLevel.warning, message, tag, extra: extra);
    _write(entry);
  }

  void error(String? tag, String message, String? extra) {
    final entry = LogEntry(LogLevel.error, message, tag, extra: extra);
    _write(entry);
  }
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
}
