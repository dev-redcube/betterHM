import 'package:better_hm/home/calendar/view/component/calendar_colorfield.dart';
import 'package:better_hm/home/calendar/view/component/calendar_textfield.dart';
import 'package:better_hm/home/calendar/viewModel/edit_calendar_viewmodel.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/components/card_with_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCustomCalendarWidget extends ConsumerStatefulWidget {
  const AddCustomCalendarWidget({super.key});

  @override
  ConsumerState<AddCustomCalendarWidget> createState() =>
      _AddCustomCalendarWidgetState();
}

class _AddCustomCalendarWidgetState
    extends ConsumerState<AddCustomCalendarWidget> {
  @override
  void initState() {
    ref.read(editCalendarViewModel).initForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: t.calendar.add.addCustomCalendar,
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CalendarTextField(
              label: t.calendar.add.fields.name.label,
              controller: ref.read(editCalendarViewModel).nameController,
              inputValid: ref.watch(editCalendarViewModel).validName,
              onChanged:
                  (text) => ref.read(editCalendarViewModel).checkNameValid(),
              placeholder: t.calendar.add.fields.name.hint,
            ),
            const SizedBox(height: 8),
            CalendarTextField(
              label: t.calendar.add.fields.url.label,
              controller: ref.read(editCalendarViewModel).urlController,
              inputValid: ref.watch(editCalendarViewModel).validUrl,
              onChanged:
                  (text) => ref.read(editCalendarViewModel).checkUrlValid(),
              placeholder: t.calendar.add.fields.url.hint,
            ),
            const SizedBox(height: 8),
            CalendarColorfield(
              color: ref.watch(editCalendarViewModel).color,
              onChanged:
                  (color) => ref.read(editCalendarViewModel).setColor(color),
            ),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: ref.watch(editCalendarViewModel).buttonActive,
              builder: (context, snapshot) {
                return FilledButton(
                  onPressed:
                      snapshot.data == true
                          ? () => ref
                              .read(editCalendarViewModel)
                              .addCalendar(context)
                          : null,
                  child: Text(t.calendar.add.label),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
