import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/pages/dashboard_page.dart';
import 'package:better_hm/pages/page_meals.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.localizations.app_name)),
      body: _pages[_selectedPage],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPage,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: context.localizations.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_rounded),
            label: context.localizations.meals,
          ),
        ],
      ),
    );
  }
}
