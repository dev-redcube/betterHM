import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddNewCalendarWidget extends StatelessWidget {
  AddNewCalendarWidget({super.key, required this.calendars, required this.add});

  final Set<Calendar> calendars;
  final void Function(Calendar) add;

  final formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final urls = calendars.map((e) => e.url);
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
                      );
                      add(calendar);
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

class InputContainer extends StatelessWidget {
  const InputContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: context.theme.colorScheme.secondaryContainer,
      ),
      child: child,
    );
  }
}
