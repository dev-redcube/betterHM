import 'package:better_hm/components/settings/settings_switch.dart';
import 'package:better_hm/components/shared/main_drawer.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/providers/prefs/prefs.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.app_bar),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(Icons.app_settings_alt_rounded),
            title: Text(t.settings.general.title),
            shape: Border.all(color: Colors.transparent),
          ),
          ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(Icons.restaurant_rounded),
            title: Text(t.settings.mealplan.title),
            shape: Border.all(color: Colors.transparent),
            children: [
              SettingsSwitch(
                title: t.settings.mealplan.showFoodLabels,
                pref: Prefs.showFoodLabels,
              )
            ],
          )
        ],
      ),
    );
  }
}
