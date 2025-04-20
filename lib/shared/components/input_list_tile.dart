import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputListTile extends StatefulWidget {
  const InputListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.enabled = true,
    this.decoration,
    this.maxLength,
    this.maxLengthEnforcement,
    this.validator,
    this.inputFormatters,
    this.maxLines,
    this.onFieldSubmitted,
  });

  final Widget title;
  final Widget? subtitle;
  final String? initialValue;

  final TextInputType? keyboardType;
  final bool enabled;
  final InputDecoration? decoration;

  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;

  final String? Function(String?)? validator;

  final List<TextInputFormatter>? inputFormatters;

  final ValueChanged? onChanged;
  final ValueChanged? onFieldSubmitted;

  @override
  State<InputListTile> createState() => _InputListTileState();
}

class _InputListTileState extends State<InputListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: TextFormField(
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          decoration: widget.decoration,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ),
    );
  }
}
