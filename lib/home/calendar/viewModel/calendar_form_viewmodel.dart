import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

final calendarFormViewModel = Provider((ref) => CalendarFormViewModel(ref));

class CalendarFormViewModel {
  BehaviorSubject<String?> validName = BehaviorSubject.seeded(null);
  BehaviorSubject<String?> validUrl = BehaviorSubject.seeded(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final BehaviorSubject<Color?> color = BehaviorSubject.seeded(null);

  BehaviorSubject<bool> buttonActive = BehaviorSubject.seeded(false);

  final Ref ref;

  CalendarFormViewModel(this.ref);

  Calendar? calendar;

  initForm({Calendar? calendar}) {
    clear();

    this.calendar = calendar;
    if (this.calendar != null) {
      nameController.text = this.calendar!.name;
      urlController.text = this.calendar!.url;
      color.add(this.calendar!.color);
    }
  }

  void checkFieldsValid() {
    _checkNameValid();
    _checkUrlValid();

    checkButton();
  }

  void _checkNameValid() {
    if (nameController.value.text.isEmpty)
      validName.add(t.calendar.add.fields.name.errors.empty);
    else
      validName.add(null);
  }

  void _checkUrlValid() {
    final text = urlController.text;

    if (text.isEmpty)
      validUrl.add(t.calendar.add.fields.url.errors.empty);
    else if (Uri.tryParse(text) == null)
      validUrl.add(t.calendar.add.fields.url.errors.invalid);
    else if (text != calendar?.url &&
        getIt<Isar>().calendars.where().urlEqualTo(text).isNotEmptySync())
      validUrl.add(t.calendar.add.fields.url.errors.notUnique);
    else
      validUrl.add(null);
  }

  void checkButton() {
    buttonActive.add(validName.value == null && validUrl.value == null);
  }

  void setColor(Color? color) {
    this.color.add(color);
    checkFieldsValid();
  }

  Future<void> save(BuildContext context, {Calendar? calendar}) async {
    if (calendar != null) {
      calendar.name = nameController.text;
      calendar.url = urlController.text;
      calendar.color = color.value;
    }

    final isar = getIt<Isar>();
    await isar.writeTxn(() async {
      await isar.calendars.put(
        calendar ??
            Calendar(
              name: nameController.text,
              url: urlController.text,
              type: CalendarType.CUSTOM,
              color: color.value,
              isActive: true,
            ),
      );
    });

    if (context.mounted) context.pop();
    clear();
  }

  void clear() {
    validName.add(null);
    validUrl.add(null);

    nameController.clear();
    urlController.clear();
    color.add(null);

    buttonActive.add(false);
  }
}
