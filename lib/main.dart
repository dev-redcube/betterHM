import 'dart:ui';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/event_data.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/routes.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:better_hm/shared/service/calendar_service.dart';
import 'package:better_hm/shared/service/location_service.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();
  LocaleSettings.useDeviceLocale();
  getIt.registerSingleton<MainApi>(MainApi.cache());
  getIt.registerSingleton<LocationService>(LocationService());

  final db = await loadDb();
  getIt.registerSingleton<Isar>(db);
  getIt.registerSingleton<CalendarService>(CalendarService());

  // TODO make better
  await getIt<CalendarService>().loadAllEvents();

  await Future.wait([
    initApp(),
    Prefs.initialLocation.waitUntilLoaded(),
    Prefs.showBackgroundJobNotification.waitUntilLoaded(),
  ]);

  runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
}

Future<Isar> loadDb() async {
  final dir = await getApplicationDocumentsDirectory();
  Isar db = await Isar.open(
    [LogEntrySchema, CalendarSchema, EventDataSchema],
    directory: dir.path,
    inspector: true,
  );
  return db;
}

Future<void> initApp() async {
  HMLogger();
  setErrorHandler();
}

Future<void> setErrorHandler() async {
  final log = Logger("HMErrorLogger");

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(details.toString(), details, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe(error.toString(), error, stack);
    return true;
  };
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  const MyApp({super.key});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      HMLogger().flush();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp.router(
          title: t.app_name,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                lightColorScheme ??
                ColorScheme.fromSeed(seedColor: const Color(0xFFE8605B)),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme:
                darkColorScheme ??
                ColorScheme.fromSeed(
                  seedColor: const Color(0xFFE8605B),
                  brightness: Brightness.dark,
                ),
          ),
          // themeMode: ThemeMode.light,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: router,
        );
      },
    );
  }
}
