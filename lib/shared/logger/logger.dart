import 'dart:developer';

import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/service/isar_service.dart';
import 'package:isar/isar.dart';

class Logger {
  final String? _tag;

  Logger(String? tag) : _tag = tag?.toUpperCase();

  void debug(String message) {
    LoggerStatic().debug(_tag, message);
  }

  void d(String message) => debug(message);

  void info(String message) {
    LoggerStatic().info(_tag, message);
  }

  void i(String message) => info(message);

  void warning(String message) {
    LoggerStatic().warning(_tag, message);
  }

  void w(String message) => warning(message);

  void error(String message) {
    LoggerStatic().error(_tag, message);
  }

  void e(String message) => error(message);
}

class LoggerStatic extends IsarService {
  static final LoggerStatic _instance = LoggerStatic._internal();
  static late final Isar _isar;

  LoggerStatic._internal();

  Future<void> init() async {
    _isar = await db;
  }

  factory LoggerStatic() => _instance;

  void _write(LogEntry entry) async {
    await _isar.writeTxn(() async {
      _isar.logEntries.put(entry);
    });
    log("${entry.level.name.toUpperCase()}: ${entry.message}");
  }

  void debug(String? tag, String message) {
    final entry = LogEntry(LogLevel.debug, message, tag);
    _write(entry);
  }

  void info(String? tag, String message) {
    final entry = LogEntry(LogLevel.info, message, tag);
    _write(entry);
  }

  void warning(String? tag, String message) {
    final entry = LogEntry(LogLevel.warning, message, tag);
    _write(entry);
  }

  void error(String? tag, String message) {
    final entry = LogEntry(LogLevel.error, message, tag);
    _write(entry);
  }
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
}
