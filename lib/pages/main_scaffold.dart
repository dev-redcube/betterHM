import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/pages/dashboard_page.dart';
import 'package:better_hm/pages/page_meals.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  MainScaffold({super.key});

  final List<_PageElement> _pages = [
    // TODO l10n
    _PageElement(
      "Dashboard",
      const Icon(Icons.home_rounded),
      const DashboardPage(),
    ),
    _PageElement(
      "Meals",
      const Icon(Icons.restaurant_rounded),
      const HomePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.localizations.app_name),
          ),
          body: const Placeholder(),
          // TODO test value
          bottomNavigationBar: constraints.maxWidth > 100
              ? null
              : BottomNavigationBar(
                  items: _pages
                      .map((e) => BottomNavigationBarItem(
                            icon: e.icon,
                            label: e.label,
                          ))
                      .toList(),
                ),
        );
      },
    );
  }
}

class _PageElement {
  final String label;
  final Icon icon;
  final Widget content;

  _PageElement(this.label, this.icon, this.content);
}
