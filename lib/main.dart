import 'dart:ui';

import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/routes.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();
  LocaleSettings.useDeviceLocale();
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
      CanteenSchema,
    ],
    directory: dir.path,
    inspector: false,
  );
  return db;
}

Future<void> initApp() async {
  HMLogger();
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
      debugPrint("[APP STATE] paused");
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
        // themeMode: ThemeMode.dark,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: router,
      );
    });
  }
}
