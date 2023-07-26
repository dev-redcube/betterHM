import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_dropdown.dart';
import 'package:better_hm/shared/components/dropdown_list_tile.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          options: LogLevel.values
              .map((e) => DropdownItem(e.name, e.index))
              .toList(),
          afterChange: (value) {
            // TODO set level on root logger
          },
        ),
        ListTile(
          title: Text(t.settings.advanced.logs.open),
          trailing: const Icon(Icons.open_in_new_rounded),
          onTap: () {
            context.pushNamed("logs");
          },
        ),
        ListTile(
          title: Text(t.settings.advanced.clearCaches.title),
          onTap: () async {
            await CanteenService().clearCanteens();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.settings.advanced.clearCaches.snackbar),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
