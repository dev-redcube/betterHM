import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/components/color_picker.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddNewCalendarWidget extends StatefulWidget {
  const AddNewCalendarWidget({
    super.key,
    required this.calendars,
    required this.add,
  });

  final Set<Calendar> calendars;
  final void Function(Calendar) add;

  @override
  State<AddNewCalendarWidget> createState() => _AddNewCalendarWidgetState();
}

class _AddNewCalendarWidgetState extends State<AddNewCalendarWidget> {
  final formKey = GlobalKey<FormState>();

  final urlController = TextEditingController();

  final nameController = TextEditingController();

  Color? color;

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.calendars.map((e) => e.url);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.calendar.edit.add.ownCalendar,
                style: context.theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              InputContainer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: t.calendar.edit.add.name.label,
                    hintText: t.calendar.edit.add.name.hint,
                    border: InputBorder.none,
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return t.calendar.edit.add.errors.emptyName;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              InputContainer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: t.calendar.edit.add.url,
                    hintText: "https://example.com/calendar.ics",
                    border: InputBorder.none,
                  ),
                  controller: urlController,
                  validator: (value) {
                    if (urls.contains(value)) {
                      return t.calendar.edit.add.errors.alreadyExists;
                    }

                    if (Uri.tryParse(value ?? "")?.hasAbsolutePath ?? false) {
                      return null;
                    }
                    return t.calendar.edit.add.errors.invalidUrl;
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              CalendarColorPicker(
                color: color,
                onColorChanged: (color) {
                  setState(() {
                    this.color = color;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      const uuid = Uuid();
                      final calendar = Calendar(
                        id: uuid.v1(),
                        isActive: true,
                        numOfFails: 0,
                        name: nameController.text,
                        url: urlController.text,
                        color: color,
                      );
                      widget.add(calendar);
                    }
                  },
                  child: Text(t.calendar.edit.add.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarColorPicker extends StatelessWidget {
  const CalendarColorPicker({
    super.key,
    this.color,
    required this.onColorChanged,
  });

  final Color? color;

  final void Function(Color? color) onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () async {
          final Color? color = await showDialog<Color?>(
            context: context,
            builder: (context) {
              return ColorPicker(
                initialColor: this.color,
              );
            },
          );

          if (color != null) {
            onColorChanged.call(color == Colors.transparent ? null : color);
          }
        },
        child: InputContainer(
          color: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                  t.calendar.edit.add.color,
                  style: context.theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({super.key, required this.child, this.color = true});

  final bool color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color ? context.theme.colorScheme.secondaryContainer : null,
      ),
      child: child,
    );
  }
}
