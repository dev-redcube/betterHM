import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
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
            title: Text(t.navigation.settings),
            leading: const Icon(Icons.settings_rounded),
            onTap: () {
              Navigator.of(context).pop();
              context.pushNamed("settings");
            },
          )
        ],
      ),
    );
  }
}
