import 'package:better_hm/home/calendar/components/input_container.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/util/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class EditCalendarPopup extends StatefulWidget {
  const EditCalendarPopup({super.key, required this.calendar});

  final Calendar calendar;

  @override
  State<EditCalendarPopup> createState() => _EditCalendarPopupState();
}

class _EditCalendarPopupState extends State<EditCalendarPopup> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController urlController;
  late Color? color;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.calendar.name);
    urlController = TextEditingController(text: widget.calendar.url);
    color = widget.calendar.color;
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Calendar"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputContainer(
              child: TextFormField(
                enabled: widget.calendar.externalId == null,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return t.calendar.add.errors.emptyName;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            InputContainer(
              child: TextFormField(
                enabled: widget.calendar.externalId == null,
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: "URL",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (Uri.tryParse(value ?? "")?.hasAbsolutePath ?? false) {
                    return null;
                  }
                  return t.calendar.add.errors.invalidUrl;
                },
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final Color? selectedColor = await showColorPicker(
                  context: context,
                  initialColor: color,
                );

                if (color != selectedColor) {
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
                            color:
                                context.theme.colorScheme.onSecondaryContainer,
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
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            t.calendar.edit.deleteLabel,
            style: TextStyle(color: context.theme.colorScheme.error),
          ),
          onPressed: () async {
            if (widget.calendar.id == null) return;

            final isar = getIt<Isar>();
            await isar.writeTxn(() async {
              await isar.calendars.delete(widget.calendar.id!);
            });

            if (context.mounted) context.pop();
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),

          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),

          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            if (widget.calendar.externalId == null) {
              widget.calendar.name = nameController.text;
              widget.calendar.url = urlController.text;
            }
            widget.calendar.color = color;

            final isar = getIt<Isar>();
            await isar.writeTxn(() async {
              isar.calendars.put(widget.calendar);
            });
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
