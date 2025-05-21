import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redcube_campus/i18n/strings.g.dart';

/// A simple color picker dialog
/// Returns the selected color or null if the dialog was closed.
/// If no color is selected or the color is unselected, [Colors.transparent] is returned
class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key, this.initialColor});

  final Color? initialColor;

  @override
  State<ColorPicker> createState() => _ColorWrapperState();
}

class _ColorWrapperState extends State<ColorPicker> {
  Color? activeColor;

  @override
  void initState() {
    super.initState();
    activeColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.shared.colorPicker.title),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: List.generate(16, (index) {
          final color = Colors.primaries[index];

          return _Color(
            color: color,
            isActive: color == activeColor,
            key: ValueKey(color),
            onTap: () {
              setState(() {
                if (color != activeColor) {
                  activeColor = color;
                } else {
                  activeColor = null;
                }
              });
            },
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(t.shared.colorPicker.cancel),
        ),
        TextButton(
          onPressed: () {
            // Needed to differentiate between unselect and closing the dialog
            context.pop(activeColor ?? Colors.transparent);
          },
          child: Text(t.shared.colorPicker.confirm),
        ),
      ],
    );
  }
}

class _Color extends StatelessWidget {
  const _Color({
    super.key,
    required this.color,
    required this.isActive,
    this.onTap,
  });

  final Color color;
  final bool isActive;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white.withAlpha(77),
        child: SizedBox(
          height: 48,
          width: 48,
          child:
              isActive
                  ? Icon(
                    Icons.check,
                    color:
                        color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                  )
                  : null,
        ),
      ),
    );
  }
}
