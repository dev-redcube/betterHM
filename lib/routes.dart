import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/home/meals/meals_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/logs_screen.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/main_drawer.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home/dashboard/manage_cards_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _mainShellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Prefs.initialLocation.value,
  routes: [
    ShellRoute(
      navigatorKey: _mainShellKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          appBar: AppBar(title: Text(t.app_name)),
          drawer: const MainDrawer(),
          body: child,
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              context.goNamed(homeRoutes[index].name!);
            },
            selectedIndex: homeRoutes.indexOf(homeRoutes
                .firstWhere((element) => element.path == state.location)),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: t.navigation.dashboard,
              ),
              NavigationDestination(
                icon: const Icon(Icons.restaurant_rounded),
                label: t.navigation.mealplan,
              ),
            ],
          ),
        );
      },
      routes: homeRoutes,
    ),
    GoRoute(
      name: SettingsScreen.routeName,
      path: "/settings",
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      name: LogsScreen.routeName,
      path: "/logs",
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          LogsScreen(levels: state.extra as Set<LogLevel>?),
    ),
  ],
);

final homeRoutes = <GoRoute>[
  GoRoute(
      name: "index",
      path: "/",
      parentNavigatorKey: _mainShellKey,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: DashboardScreen()),
      routes: <GoRoute>[
        GoRoute(
          name: ManageCardsScreen.routeName,
          path: "manageCards",
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const ManageCardsScreen(),
        ),
      ]),
  GoRoute(
    name: "meals",
    path: "/meals",
    parentNavigatorKey: _mainShellKey,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: MealsScreen()),
  ),
];
