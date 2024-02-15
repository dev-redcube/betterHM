import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class AddCalendarScreen extends StatelessWidget {
  const AddCalendarScreen({super.key});

  static const String routeName = "calendar.add";

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = context.theme.textTheme.headlineSmall;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Calendar"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text("Add Own Calendar", style: textStyle),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
            child: _AddNewCalendarWidget(),
          ),
          Text("Or add existing", style: textStyle),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: _AddExistingCalendarWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNewCalendarWidget extends StatefulWidget {
  const _AddNewCalendarWidget({super.key});

  @override
  State<_AddNewCalendarWidget> createState() => _AddNewCalendarWidgetState();
}

class _AddNewCalendarWidgetState extends State<_AddNewCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Calendar URL",
              hintText: "https://example.com/calendar.ics",
            ),
            validator: (value) {
              if (Uri.tryParse(value ?? "")?.hasAbsolutePath ?? false) {
                return null;
              }
              return "Invalid url";
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Calendar Name",
              hintText: "My Calendar",
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Name cannot be empty";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Add the calendar to the database
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _AddExistingCalendarWidget extends StatelessWidget {
  const _AddExistingCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CalendarService().getAvailableCalendars(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.topLeft,
            child: LinearProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        final calendars = snapshot.data;

        return ListView.builder(
          itemCount: calendars!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(calendars[index].name),
              onTap: () {
                // Add the calendar to the database
              },
            );
          },
        );
      },
    );
  }
}
