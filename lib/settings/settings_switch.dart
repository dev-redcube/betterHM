import 'package:flutter/material.dart';
import 'package:redcube_campus/settings/settings_screen.dart';
import 'package:redcube_campus/shared/prefs.dart';

class SettingsSwitch extends StatefulWidget {
  const SettingsSwitch({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconBuilder,
    this.enabled,
    required this.pref,
    this.afterChange,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconData? Function(bool)? iconBuilder;
  final bool? enabled;
  final IPref<bool> pref;
  final ValueChanged<bool>? afterChange;

  @override
  State<SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  @override
  void initState() {
    super.initState();
    widget.pref.addListener(onChanged);
  }

  void onChanged() {
    widget.afterChange?.call(widget.pref.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    IconData? icon = widget.icon;
    icon ??= widget.iconBuilder?.call(widget.pref.value);
    icon ??= Icons.settings_rounded;

    return GestureDetector(
      onLongPress: () {
        SettingsScreen.showResetDialog(
          context: context,
          pref: widget.pref,
          prefTitle: widget.title,
        );
      },
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        title: Text(widget.title),
        subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
        value: widget.pref.value,
        onChanged: (bool value) {
          widget.pref.value = value;
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.pref.removeListener(onChanged);
    super.dispose();
  }
}
