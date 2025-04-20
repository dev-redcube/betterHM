import 'package:better_hm/home/calendar/add/add_screen.dart';
import 'package:better_hm/home/calendar/calendar_screen.dart';
import 'package:better_hm/home/calendar/edit_screen.dart';
import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/home/dashboard/sections/kino/detail_view/movie_detail_screen.dart';
import 'package:better_hm/home/dashboard/sections/kino/movie.dart';
import 'package:better_hm/home/meals/meals_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/log_details_screen.dart';
import 'package:better_hm/settings/logs/logs_screen.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _mainShellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Prefs.initialLocation.value,
  routes: [
    ShellRoute(
      navigatorKey: _mainShellKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              body: Row(
                children: [
                  if (constraints.maxWidth >= 550)
                    NavigationRail(
                      extended: constraints.maxWidth > 800,
                      destinations: [
                        NavigationRailDestination(
                          icon: const Icon(Icons.home_rounded),
                          label: Text(t.navigation.dashboard),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.calendar_month_rounded),
                          label: Text(t.navigation.calendar),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.restaurant_rounded),
                          label: Text(t.navigation.mealplan),
                        ),
                      ],
                      selectedIndex: homeRoutes.indexOf(
                        homeRoutes.firstWhere(
                          (element) => element.path == state.uri.toString(),
                        ),
                      ),
                      onDestinationSelected: (int index) {
                        context.goNamed(homeRoutes[index].name!);
                      },
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar:
                  constraints.maxWidth < 550
                      ? NavigationBar(
                        onDestinationSelected: (int index) {
                          context.goNamed(homeRoutes[index].name!);
                        },
                        selectedIndex: homeRoutes.indexOf(
                          homeRoutes.firstWhere(
                            (element) => element.path == state.uri.toString(),
                          ),
                        ),
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
                      )
                      : null,
            );
          },
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
          builder:
              (context, state) =>
                  LogDetailsScreen(id: state.pathParameters["id"]),
        ),
      ],
    ),
    GoRoute(
      name: MovieDetailPage.routeName,
      path: "/movie",
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final x = state.extra as (List<Movie>, int);
        return MovieDetailsScreen(movies: x.$1, initialMovie: x.$2);
      },
    ),
  ],
);

final homeRoutes = <GoRoute>[
  GoRoute(
    name: "index",
    path: "/",
    parentNavigatorKey: _mainShellKey,
    pageBuilder:
        (context, state) => const NoTransitionPage(child: DashboardScreen()),
  ),
  GoRoute(
    name: "calendar",
    path: "/calendar",
    parentNavigatorKey: _mainShellKey,
    pageBuilder:
        (context, state) => const NoTransitionPage(child: CalendarScreen()),
    routes: <GoRoute>[
      GoRoute(
        name: CalendarEditScreen.routeName,
        path: "edit",
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CalendarEditScreen(),
        routes: <GoRoute>[
          GoRoute(
            name: AddCalendarScreen.routeName,
            path: "add",
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => AddCalendarScreen(),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    name: "meals",
    path: "/meals",
    parentNavigatorKey: _mainShellKey,
    pageBuilder: (context, state) => NoTransitionPage(child: MealsScreen()),
  ),
];
