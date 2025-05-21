import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/main.dart';
import 'package:redcube_campus/settings/settings_dropdown.dart';
import 'package:redcube_campus/settings/settings_switch.dart';
import 'package:redcube_campus/shared/components/dropdown_list_tile.dart';
import 'package:redcube_campus/shared/logger/log_entry.dart';
import 'package:redcube_campus/shared/logger/logger.dart';
import 'package:redcube_campus/shared/networking/main_api.dart';
import 'package:redcube_campus/shared/prefs.dart';

class AdvancedSettingsSection extends StatelessWidget {
  const AdvancedSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      leading: const Icon(Icons.warning_rounded),
      title: Text(t.settings.advanced.title),
      shape: Border.all(color: Colors.transparent),
      children: [
        SettingsDropdown<int>(
          title: t.settings.advanced.logLevel,
          pref: Prefs.logLevel,
          options:
              LogLevel.values
                  .map((e) => DropdownItem(e.name, e.index))
                  .toList(),
          afterChange: (int value) {
            HMLogger().level = Level.LEVELS[value];
          },
        ),
        ListTile(
          title: Text(t.settings.advanced.logs.open),
          trailing: const Icon(Icons.open_in_new_rounded),
          onTap: () {
            context.pushNamed("logs");
          },
        ),
        SettingsSwitch(
          title: t.settings.advanced.showBackgroundJobNotification.label,
          subtitle: t.settings.advanced.showBackgroundJobNotification.subtitle,
          pref: Prefs.showBackgroundJobNotification,
          afterChange: (val) async {
            if (!val) return;
            PermissionStatus? status = await Permission.notification.request();
            if (status != PermissionStatus.granted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enable Notifications")),
              );
              Prefs.showBackgroundJobNotification.value = false;
            }
          },
        ),
        SettingsSwitch(
          title: t.settings.advanced.devMode.title,
          subtitle: t.settings.advanced.devMode.subtitle,
          pref: Prefs.devMode,
        ),
        ListTile(
          title: Text(t.settings.advanced.clearCaches.title),
          onTap: () {
            getIt.get<MainApi>().clearCache();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.settings.advanced.clearCaches.snackbar)),
            );
          },
        ),
      ],
    );
  }
}
