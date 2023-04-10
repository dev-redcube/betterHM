import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/screens/dashboard_screen.dart';
import 'package:better_hm/screens/meals_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.app_name)),
          body: child,
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              context.goNamed(homeRoutes[index].name!);
            },
            selectedIndex: homeRoutes.indexOf(homeRoutes.firstWhere((element) => element.path == state.location)),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: context.l10n.dashboard,
              ),
              NavigationDestination(
                icon: const Icon(Icons.restaurant_rounded),
                label: context.l10n.meals,
              ),
            ],
          ),
        );
      },
      routes: homeRoutes,
    ),
  ],
);

final homeRoutes = <GoRoute>[
  GoRoute(
    name: "index",
    path: "/",
    builder: (context, state) => const DashboardScreen(),
  ),
  GoRoute(
    name: "meals",
    path: "/meals",
    builder: (context, state) => const MealsScreen(),
  ),
];