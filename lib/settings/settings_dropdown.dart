import 'package:flutter/material.dart';
import 'package:redcube_campus/settings/settings_screen.dart';
import 'package:redcube_campus/shared/components/dropdown_list_tile.dart';
import 'package:redcube_campus/shared/prefs.dart';

class SettingsDropdown<T> extends StatefulWidget {
  const SettingsDropdown({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconBuilder,
    required this.pref,
    this.afterChange,
    required this.options,
  }) : assert(icon == null || iconBuilder == null);

  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconData? Function(bool)? iconBuilder;
  final IPref<T> pref;
  final ValueChanged<T>? afterChange;
  final List<DropdownItem<T>> options;

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState<T>();
}

class _SettingsDropdownState<T> extends State<SettingsDropdown<T>> {
  @override
  void initState() {
    super.initState();
    widget.pref.addListener(onChanged);
  }

  onChanged() {
    widget.afterChange?.call(widget.pref.value);
    setState(() {});
  }

  @override
  void dispose() {
    widget.pref.removeListener(onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        SettingsScreen.showResetDialog(
          context: context,
          pref: widget.pref,
          prefTitle: widget.title,
        );
      },
      child: InkWell(
        child: ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 16,
          ),
          title: Text(widget.title),
          subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
          trailing: DropdownButton<T>(
            items:
                widget.options
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(e.name),
                        ),
                      ),
                    )
                    .toList(),
            value: widget.pref.value,
            onChanged: (T? value) {
              if (value == null) return;
              widget.pref.value = value;
            },
            borderRadius: BorderRadius.circular(32),
            underline: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
