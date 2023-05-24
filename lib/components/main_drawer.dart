import 'package:better_hm/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text(context.l10n.app_name)),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: Text(context.l10n.settings),
            onTap: () {
              context.pushNamed("settings");
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
