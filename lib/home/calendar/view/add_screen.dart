import 'package:better_hm/home/calendar/view/component/add_custom_calendar.dart';
import 'package:better_hm/home/calendar/view/component/add_predefined_calendar.dart';
import 'package:better_hm/home/calendar/viewModel/calendar_form_viewmodel.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/components/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarAddScreen extends ConsumerWidget {
  const CalendarAddScreen({super.key});

  static const routeName = "calendars.add";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.calendar.add.title),
        leading: CustomBackButton(
          beforeOnPressed: () => ref.read(calendarFormViewModel).clear(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddCustomCalendarWidget(),
          Expanded(child: AddPredefinedCalendarWidget()),
        ],
      ),
    );
  }
}
