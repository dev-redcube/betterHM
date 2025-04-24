import 'package:better_hm/home/calendar/view/component/input_container.dart';
import 'package:better_hm/shared/components/card_with_title.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/util/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:better_hm/i18n/strings.g.dart';

class AddCustomCalendarWidget extends StatefulWidget {
  const AddCustomCalendarWidget({super.key});

  @override
  State<AddCustomCalendarWidget> createState() =>
      _AddCustomCalendarWidgetState();
}

class _AddCustomCalendarWidgetState extends State<AddCustomCalendarWidget> {
  late final TextEditingController nameController;

  late final TextEditingController urlController;

  Color? color;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    urlController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: t.calendar.add.addCustomCalendar,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InputContainer(
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: t.calendar.add.fields.name.label,
                hintText: t.calendar.add.fields.name.hint,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          InputContainer(
            child: TextFormField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: t.calendar.add.fields.url.label,
                hintText: t.calendar.add.fields.url.hint,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final Color? selectedColor = await showColorPicker(
                context: context,
                initialColor: color,
              );

              if (color?.toARGB32() != selectedColor?.toARGB32()) {
                setState(() {
                  color = selectedColor;
                });
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: InputContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: color,
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
          ),
          const SizedBox(height: 16),
          FilledButton(child: Text("Add"), onPressed: () {}),
        ],
      ),
    );
  }
}
