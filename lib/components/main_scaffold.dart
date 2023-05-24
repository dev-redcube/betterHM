import 'package:better_hm/components/main_drawer.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState routerState;

  const MainScaffold({Key? key, required this.child, required this.routerState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.app_name),
      ),
      drawer: const MainDrawer(),
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          context.goNamed(homeRoutes[index].name!);
        },
        selectedIndex: homeRoutes.indexOf(homeRoutes
            .firstWhere((element) => element.path == routerState.location)),
        destinations: primaryNavigationDestinations(context),
      ),
    );
  }
}

List<NavigationDestination> primaryNavigationDestinations(
        BuildContext context) =>
    [
      NavigationDestination(
        icon: const Icon(Icons.home_rounded),
        label: context.l10n.dashboard,
      ),
      NavigationDestination(
        icon: const Icon(Icons.restaurant_rounded),
        label: context.l10n.meals,
      ),
    ];
