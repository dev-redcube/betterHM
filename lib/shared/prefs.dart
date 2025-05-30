/// This File is taken mostly from https://github.com/adil192/saber/blob/main/lib/data/prefs.dart
/// Credit for this file goes to adil192
library;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:redcube_campus/home/dashboard/sections/mvg/stations.dart';
import 'package:redcube_campus/shared/logger/log_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Prefs {
  /// If true, the user's preferences will not be loaded and the default values will be used instead.
  /// The values will not be saved either.
  @visibleForTesting
  static bool testingMode = false;

  /// If true, a warning will be printed if a pref is accessed before it is loaded.
  ///
  /// If [testingMode] is true, the warning will not be printed even if this is true.
  @visibleForTesting
  static bool warnIfPrefAccessedBeforeLoaded = true;

  static bool initialized = false;

  // General
  static late final PlainPref<String> initialLocation;

  // Dashboard
  static late final PlainPref<String> lastMvgStation;

  // Calendar
  static late final PlainPref<int> calendarViewConfiguration;

  // Mealplan
  static late final PlainPref<bool> showFoodLabels;
  static late final PlainPref<String> lastCanteen;

  // Advanced
  static late final PlainPref<int> logLevel;
  static late final PlainPref<bool> showBackgroundJobNotification;
  static late final PlainPref<bool> devMode;

  static void init() {
    if (initialized) {
      return;
    }
    // General
    initialLocation = PlainPref("initialLocation", "/");

    // Dashboard
    lastMvgStation = PlainPref("lastMvgStation", stations.first.id);

    // Calendar
    calendarViewConfiguration = PlainPref("calendarViewConfiguration", 1);

    // Mealplan
    showFoodLabels = PlainPref("showFoodLabels", true);
    lastCanteen = PlainPref("lastCanteen", "MENSA_LOTHSTR");

    // Advanced
    logLevel = PlainPref("logLevel", LogLevel.INFO.index);
    showBackgroundJobNotification = PlainPref(
      "showBackgroundJobNotification",
      false,
    );
    devMode = PlainPref("devMode", false);

    initialized = true;
  }

  static bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;
}

abstract class IPref<T> extends ValueNotifier<T> {
  final String key;

  /// The keys that were used in the past for this Pref. If one of these keys is found, the value will be migrated to the current key.
  final List<String> historicalKeys;

  /// The keys that were used in the past for a similar Pref. If one of these keys is found, it will be deleted.
  final List<String> deprecatedKeys;

  final T defaultValue;

  bool _loaded = false;

  /// Whether this pref has changes that have yet to be saved to disk.
  @protected
  bool _saved = true;

  IPref(
    this.key,
    this.defaultValue, {
    List<String>? historicalKeys,
    List<String>? deprecatedKeys,
  }) : historicalKeys = historicalKeys ?? [],
       deprecatedKeys = deprecatedKeys ?? [],
       super(defaultValue) {
    if (Prefs.testingMode) {
      _loaded = true;
      return;
    } else {
      _load().then((T? loadedValue) {
        _loaded = true;
        if (loadedValue != null) {
          value = loadedValue;
        }
        _afterLoad();
        addListener(_save);
      });
    }
  }

  Future<T?> _load();

  Future<void> _afterLoad();

  Future<void> _save();

  @protected
  Future<T?> getValueWithKey(String key);

  /// Removes the value from shared preferences, and resets the pref to its default value.
  @visibleForTesting
  Future<void> delete();

  @override
  T get value {
    if (!loaded && !Prefs.testingMode && Prefs.warnIfPrefAccessedBeforeLoaded) {
      Logger("prefs").warning("Pref '$key' accessed before it was loaded");
    }
    return super.value;
  }

  bool get loaded => _loaded;

  bool get saved => _saved;

  Future<void> waitUntilLoaded() async {
    while (!loaded) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Waits until the value has been saved to disk.
  /// Note that there is no guarantee with shared preferences that
  /// the value will actually be saved to disk.
  @visibleForTesting
  Future<void> waitUntilSaved() async {
    while (!saved) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Lets us use notifyListeners outside of the class
  /// as super.notifyListeners is @protected
  @override
  void notifyListeners() => super.notifyListeners();
}

class PlainPref<T> extends IPref<T> {
  SharedPreferences? _prefs;

  PlainPref(
    super.key,
    super.defaultValue, {
    super.historicalKeys,
    super.deprecatedKeys,
  }) {
    // Accepted types
    assert(
      T == bool ||
          T == int ||
          T == double ||
          T == String ||
          T == typeOf<Uint8List?>() ||
          T == typeOf<List<String>>() ||
          T == typeOf<Set<String>>() ||
          T == typeOf<Queue<String>>(),
    );
  }

  @override
  Future<T?> _load() async {
    _prefs ??= await SharedPreferences.getInstance();

    T? currentValue = await getValueWithKey(key);
    if (currentValue != null) return currentValue;

    for (String historicalKey in historicalKeys) {
      currentValue = await getValueWithKey(historicalKey);
      if (currentValue == null) continue;

      // migrate to new key
      await _save();
      _prefs!.remove(historicalKey);

      return currentValue;
    }

    for (String deprecatedKey in deprecatedKeys) {
      _prefs!.remove(deprecatedKey);
    }

    return null;
  }

  @override
  Future<void> _afterLoad() async {
    _prefs = null;
  }

  @override
  Future _save() async {
    _saved = false;
    try {
      _prefs ??= await SharedPreferences.getInstance();

      if (T == bool) {
        return await _prefs!.setBool(key, value as bool);
      } else if (T == int) {
        return await _prefs!.setInt(key, value as int);
      } else if (T == double) {
        return await _prefs!.setDouble(key, value as double);
      } else if (T == typeOf<Uint8List?>()) {
        Uint8List? bytes = value as Uint8List?;
        if (bytes == null) {
          return await _prefs!.remove(key);
        } else {
          return await _prefs!.setString(key, base64Encode(bytes));
        }
      } else if (T == typeOf<List<String>>()) {
        return await _prefs!.setStringList(key, value as List<String>);
      } else if (T == typeOf<Set<String>>()) {
        return await _prefs!.setStringList(
          key,
          (value as Set<String>).toList(),
        );
      } else if (T == typeOf<Queue<String>>()) {
        return await _prefs!.setStringList(
          key,
          (value as Queue<String>).toList(),
        );
      } else {
        return await _prefs!.setString(key, value as String);
      }
    } finally {
      _saved = true;
    }
  }

  @override
  Future<T?> getValueWithKey(String key) async {
    try {
      if (!_prefs!.containsKey(key)) {
        return null;
      } else if (T == typeOf<Uint8List?>()) {
        String? base64 = _prefs!.getString(key);
        if (base64 == null) return null;
        return base64Decode(base64) as T;
      } else if (T == typeOf<List<String>>()) {
        return _prefs!.getStringList(key) as T?;
      } else if (T == typeOf<Set<String>>()) {
        return _prefs!.getStringList(key)?.toSet() as T?;
      } else if (T == typeOf<Queue<String>>()) {
        List? list = _prefs!.getStringList(key);
        return list != null ? Queue<String>.from(list) as T : null;
      } else {
        return _prefs!.get(key) as T?;
      }
    } catch (e) {
      Logger("prefs").warning("Error loading $key: $e");
      return null;
    }
  }

  @override
  Future<void> delete() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(key);
  }
}

class TransformedPref<T_in, T_out> extends IPref<T_out> {
  final IPref<T_in> pref;
  final T_out Function(T_in) transform;
  final T_in Function(T_out) reverseTransform;

  @override
  T_out get value => transform(pref.value);

  @override
  set value(T_out value) => pref.value = reverseTransform(value);

  @override
  bool get loaded => pref.loaded;

  @override
  bool get saved => pref.saved;

  TransformedPref(this.pref, this.transform, this.reverseTransform)
    : super(pref.key, transform(pref.defaultValue)) {
    pref.addListener(notifyListeners);
  }

  @override
  Future<void> _afterLoad() async {}

  @override
  Future<T_out?> _load() async => null;

  @override
  Future<void> _save() async {}

  @override
  Future<void> delete() async {}

  @override
  Future<T_out?> getValueWithKey(String key) async => null;
}

Type typeOf<T>() => T;
