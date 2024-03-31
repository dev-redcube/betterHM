import 'package:better_hm/home/calendar/add/add_new_calendar.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.calendar.name);
    urlController = TextEditingController(text: widget.calendar.url);
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
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return t.calendar.edit.add.errors.emptyName;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            InputContainer(
              child: TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: "URL",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (Uri.tryParse(value ?? "")?.hasAbsolutePath ?? false) {
                    return null;
                  }
                  return t.calendar.edit.add.errors.invalidUrl;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            final db = Isar.getInstance();
            await db?.writeTxn(() async {
              widget.calendar.name = nameController.text;
              widget.calendar.url = urlController.text;
              db.calendars.put(widget.calendar);
            });
            final icalService = ICalService(updateCalendarController: true);
            icalService.syncSingle(widget.calendar);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),
        ),
      ],
    );
  }
}
