import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/pages/dashboard_page.dart';
import 'package:better_hm/pages/page_meals.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedPage = 0;

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
          body: _pages[_selectedPage].content,
          bottomNavigationBar: constraints.maxWidth >= 800
              ? null
              : NavigationBar(
                  selectedIndex: _selectedPage,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedPage = index;
                    });
                  },
                  destinations: _pages
                      .map((e) => NavigationDestination(
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
