import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<Color?> showColorPicker({
  required BuildContext context,
  Color? initialColor,
  Iterable<Color>? colorPool,
}) {
  // Default color pool is the Color primaries [Colors.primaries]
  colorPool ??= List.generate(
    Colors.primaries.length,
    (index) => Colors.primaries[index],
  );

  return showDialog<Color?>(
    context: context,
    builder:
        (BuildContext context) => _ColorPickerWidget(
          colorPool: colorPool!,
          initialColor: initialColor,
        ),
  );
}

class _ColorPickerWidget extends StatefulWidget {
  const _ColorPickerWidget({required this.colorPool, this.initialColor});

  final Iterable<Color> colorPool;
  final Color? initialColor;

  @override
  State<_ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<_ColorPickerWidget> {
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
        children:
            widget.colorPool
                .map(
                  (color) => _Color(
                    key: ValueKey(color),
                    color: color,
                    isActive: color.toARGB32() == activeColor?.toARGB32(),
                    onTap: () {
                      setState(() {
                        if (color != activeColor)
                          activeColor = color;
                        else
                          activeColor = null;
                      });
                    },
                  ),
                )
                .toList(),
      ),
      actions: [
        TextButton(
          child: Text(t.shared.colorPicker.cancel),
          onPressed: () {
            context.pop();
          },
        ),
        TextButton(
          child: Text(t.shared.colorPicker.confirm),
          onPressed: () {
            context.pop(activeColor);
          },
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
    required this.onTap,
  });

  final Color color;
  final bool isActive;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8.0),
      elevation: 0,
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
                    Icons.check_rounded,
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
