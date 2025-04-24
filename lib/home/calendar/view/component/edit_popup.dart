import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/view/component/calendar_colorfield.dart';
import 'package:better_hm/home/calendar/view/component/calendar_textfield.dart';
import 'package:better_hm/home/calendar/viewModel/calendar_form_viewmodel.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class EditCalendarPopup extends ConsumerStatefulWidget {
  const EditCalendarPopup({super.key, required this.calendar});

  final Calendar calendar;

  @override
  ConsumerState<EditCalendarPopup> createState() => _EditCalendarPopupState();
}

class _EditCalendarPopupState extends ConsumerState<EditCalendarPopup> {
  @override
  void initState() {
    super.initState();
    ref
        .read(calendarFormViewModel)
        .initForm(
          name: widget.calendar.name,
          url: widget.calendar.url,
          color: widget.calendar.color,
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.calendar.edit.title),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalendarTextField(
              label: t.calendar.add.fields.name.label,
              controller: ref.read(calendarFormViewModel).nameController,
              inputValid: ref.watch(calendarFormViewModel).validName,
              onChanged:
                  (text) => ref.read(calendarFormViewModel).checkFieldsValid(),
              placeholder: t.calendar.add.fields.name.hint,
            ),
            const SizedBox(height: 8),
            CalendarTextField(
              label: t.calendar.add.fields.url.label,
              controller: ref.read(calendarFormViewModel).urlController,
              inputValid: ref.watch(calendarFormViewModel).validUrl,
              onChanged:
                  (text) => ref.read(calendarFormViewModel).checkFieldsValid(),
              placeholder: t.calendar.add.fields.url.hint,
            ),
            const SizedBox(height: 8),
            CalendarColorfield(
              color: ref.watch(calendarFormViewModel).color,
              onChanged:
                  (color) => ref.read(calendarFormViewModel).setColor(color),
            ),
          ],
        ),
      ),
      actions: [
        // Delete Button
        TextButton(
          child: Text(
            t.calendar.edit.deleteLabel,
            style: TextStyle(color: context.theme.colorScheme.error),
          ),
          onPressed: () async {
            // Shouldn't happen. Just to be sure
            if (widget.calendar.id == null) return;

            final isar = getIt<Isar>();
            await isar.writeTxn(() async {
              await isar.calendars.delete(widget.calendar.id!);
            });

            if (context.mounted) context.pop();
          },
        ),
        // Cancel Button
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),

          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // Submit Button
        StreamBuilder(
          stream: ref.watch(calendarFormViewModel).buttonActive,
          builder: (context, snapshot) {
            return TextButton(
              onPressed:
                  snapshot.data == true
                      ? () => ref
                          .read(calendarFormViewModel)
                          .save(context, calendar: widget.calendar)
                      : null,
              child: Text(MaterialLocalizations.of(context).saveButtonLabel),
            );
          },
        ),
      ],
    );
  }
}
