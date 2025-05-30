import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/settings/app_info.dart';
import 'package:redcube_campus/settings/sections/advanced.dart';
import 'package:redcube_campus/settings/sections/general.dart';
import 'package:redcube_campus/settings/sections/mealplan.dart';
import 'package:redcube_campus/shared/prefs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const initiallyExpanded = true;
  static const routeName = "settings";

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
      builder:
          (context) => AlertDialog(
            title: Text(t.settings.reset.title),
            content: Text(prefTitle),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.app_bar)),
      body: const Column(
        children: [
          AppInfo(),
          GeneralSettingsSection(),
          MealplanSettingsSection(),
          AdvancedSettingsSection(),
        ],
      ),
    );
  }
}
