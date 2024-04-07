import 'dart:ui';

import 'package:better_hm/home/calendar/calendar_body.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/parse_events.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/routes.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/networking/main_api.dart';
import 'package:better_hm/shared/prefs.dart';
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
import 'package:workmanager/workmanager.dart';

import 'home/calendar/background_service/background_service.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();
  LocaleSettings.useDeviceLocale();
  getIt.registerSingleton<MainApi>(MainApi.cache());
  getIt.registerSingleton<LocationService>(LocationService());

  await loadDb();
  await Future.wait([
    initApp(),
    Prefs.initialLocation.waitUntilLoaded(),
    Prefs.mouseScroll.waitUntilLoaded(),
  ]);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().registerPeriodicTask(
    calendarSyncKey,
    calendarSyncKey,
    frequency: const Duration(hours: 12),
  );

  parseAllEvents().then((value) => eventsController.addEvents(value));

  runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
}

Future<Isar> loadDb() async {
  final dir = await getApplicationDocumentsDirectory();
  Isar db = await Isar.open(
    [
      LogEntrySchema,
      CalendarSchema,
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

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(details.toString(), details, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe(error.toString(), error, stack);
    return true;
  };
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        // The VoiceAccess sends pointer events with unknown type when scrolling
        // scrollables.
        PointerDeviceKind.unknown,
      };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      HMLogger().flush();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();
    Prefs.mouseScroll.addListener(onPrefChange);
  }

  void onPrefChange() {
    setState(() {});
  }

  @override
  void dispose() {
    Prefs.mouseScroll.removeListener(onPrefChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp.router(
          title: t.app_name,
          scrollBehavior:
              Prefs.mouseScroll.value ? CustomScrollBehavior() : null,
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
      },
    );
  }
}
