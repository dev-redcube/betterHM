import 'package:better_hm/home/calendar/view/component/input_container.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/util/color_picker.dart';
import 'package:flutter/material.dart';

class CalendarColorfield extends StatelessWidget {
  const CalendarColorfield({
    super.key,
    required this.color,
    required this.onChanged,
  });

  final Stream<Color?> color;
  final void Function(Color?) onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: color,
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            final Color? selectedColor = await showColorPicker(
              context: context,
              initialColor: snapshot.data,
            );

            if (snapshot.data?.toARGB32() != selectedColor?.toARGB32())
              onChanged(selectedColor);
          },
          borderRadius: BorderRadius.circular(8),
          child: InputContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: snapshot.data,
                      border: Border.all(
                        color: context.theme.colorScheme.onSecondaryContainer,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    t.calendar.add.color,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
