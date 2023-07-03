import 'package:flutter/material.dart';

class DropdownListTile<T> extends StatefulWidget {
  const DropdownListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.options,
    this.initialValue,
    this.onChanged,
  });

  final String title;
  final String? subtitle;

  final Iterable<DropdownItem<T>> options;
  final T? initialValue;

  final ValueChanged<T>? onChanged;

  @override
  State<DropdownListTile> createState() => _DropdownListTileState();
}

class _DropdownListTileState<T> extends State<DropdownListTile<T>> {
  late final T? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      trailing: DropdownButton<T>(
        value: value,
        onChanged: (T? value) {},
        items: widget.options
            .map((e) => DropdownMenuItem(
                  value: e.value,
                  child: Text(e.name),
                ))
            .toList(),
        underline: const SizedBox.shrink(),
      ),
    );
  }
}

class DropdownItem<T> {
  final String name;
  final T value;

  DropdownItem(this.name, this.value);
}
