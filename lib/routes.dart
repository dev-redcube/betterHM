import 'package:better_hm/components/shared/main_drawer.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/screens/dashboard_screen.dart';
import 'package:better_hm/screens/meals_screen.dart';
import 'package:better_hm/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _mainShellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
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
