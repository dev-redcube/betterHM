import 'dart:ui';

import 'package:better_hm/firebase_options.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/routes.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Prefs.init();
  LocaleSettings.useDeviceLocale();
  getIt.registerSingleton<MainApi>(MainApi.cache());

  await loadDb();
  await Future.wait([
    initApp(),
    Prefs.initialLocation.waitUntilLoaded(),
  ]);
  runApp(TranslationProvider(child: const MyApp()));
}

Future<Isar> loadDb() async {
  final dir = await getApplicationDocumentsDirectory();
  Isar db = await Isar.open(
    [
      LogEntrySchema,
    ],
    directory: dir.path,
    inspector: false,
  );
  return db;
}

Future<void> initApp() async {
  HMLogger();
  setErrorHandler();
}

Future<void> setErrorHandler() async {
  final log = Logger("HMErrorLogger");
  await Prefs.enableCrashlytics.waitUntilLoaded();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(details.toString(), details, details.stack);
    if (kReleaseMode && Prefs.enableCrashlytics.value) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe(error.toString(), error, stack);
    if (kReleaseMode && Prefs.enableCrashlytics.value) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
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
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        title: t.app_name,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme ??
              ColorScheme.fromSeed(seedColor: const Color(0xFFE8605B)),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme ??
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
    });
  }
}
