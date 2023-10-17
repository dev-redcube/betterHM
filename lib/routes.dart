import 'package:better_hm/home/calendar/calendar_screen.dart';
import 'package:better_hm/home/dashboard/card_settings_screen.dart';
import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/home/meals/meals_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/log_details_screen.dart';
import 'package:better_hm/settings/logs/logs_screen.dart';
import 'package:better_hm/settings/settings_screen.dart';
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
          appBar: AppBar(
            title: Text(t.app_name),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {
                  context.pushNamed(SettingsScreen.routeName);
                },
              ),
            ],
          ),
          body: child,
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              context.goNamed(homeRoutes[index].name!);
            },
            selectedIndex: homeRoutes.indexOf(homeRoutes
                .firstWhere((element) => element.path == state.uri.toString())),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: t.navigation.dashboard,
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_rounded),
                label: t.navigation.calendar,
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
      builder: (context, state) => const LogsScreen(),
      routes: <GoRoute>[
        GoRoute(
          name: LogDetailsScreen.routeName,
          path: ":id",
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) =>
              LogDetailsScreen(id: state.pathParameters["id"]),
        )
      ],
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
          routes: <GoRoute>[
            GoRoute(
              name: CardSettingsScreen.routeName,
              path: "cardSettings",
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) =>
                  CardSettingsScreen(child: state.extra as Widget),
            )
          ],
        ),
      ]),
  GoRoute(
    name: "calendar",
    path: "/calendar",
    parentNavigatorKey: _mainShellKey,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: CalendarScreen()),
  ),
  GoRoute(
    name: "meals",
    path: "/meals",
    parentNavigatorKey: _mainShellKey,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: MealsScreen()),
  ),
];
