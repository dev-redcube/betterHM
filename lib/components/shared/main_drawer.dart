import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Center(
                  child: Text(
            t.app_name,
            style: context.theme.textTheme.headlineLarge,
          ))),
          ListTile(
            title: const Text("Meals"),
            onTap: () {
              context.goNamed("meals");
            },
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              context.goNamed("settings");
            },
          )
        ],
      ),
    );
  }
}
