import 'package:better_hm/components/settings/app_info.dart';
import 'package:better_hm/components/settings/settings_dropdown.dart';
import 'package:better_hm/components/settings/settings_switch.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/providers/prefs/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

  static Future<bool?> showResetDialog({
    required BuildContext context,
    required IPref pref,
    required String prefTitle,
  }) async {
    HapticFeedback.lightImpact();
    if (pref.value == pref.defaultValue) return null;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.reset.title),
        content: Text(prefTitle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              pref.value = pref.defaultValue;
              Navigator.of(context).pop(true);
            },
            child: Text(t.settings.reset.confirm),
          ),
        ],
      ),
    );
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const initiallyExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.app_bar),
      ),
      body: Column(
        children: [
          const AppInfo(),
          // ExpansionTile(
          //   initiallyExpanded: true,
          //   leading: const Icon(Icons.app_settings_alt_rounded),
          //   title: Text(t.settings.general.title),
          //   shape: Border.all(color: Colors.transparent),
          // ),
          ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            leading: const Icon(Icons.home_rounded),
            title: Text(t.settings.dashboard.title),
            shape: Border.all(color: Colors.transparent),
            children: [
              SettingsDropdown<int>(
                title: t.settings.dashboard.numberOfEventsToShow,
                pref: Prefs.numberOfEventsToShow,
                options: List.generate(
                  8,
                  (index) => DropdownItem((++index).toString(), index),
                ),
              ),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: initiallyExpanded,
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
