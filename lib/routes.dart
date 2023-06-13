import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/home/meals/meals_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/logs_screen.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/main_drawer.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _mainShellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
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
      name: "settings",
      path: "/settings",
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      name: "logs",
      path: "/logs",
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const LogsScreen(),
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
  ),
  GoRoute(
    name: "meals",
    path: "/meals",
    parentNavigatorKey: _mainShellKey,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: MealsScreen()),
  ),
];
