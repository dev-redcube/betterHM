import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

final editCalendarViewModel = Provider((ref) => EditCalendarViewModel(ref));

class EditCalendarViewModel {
  BehaviorSubject<String?> validName = BehaviorSubject.seeded(null);
  BehaviorSubject<String?> validUrl = BehaviorSubject.seeded(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final BehaviorSubject<Color?> color = BehaviorSubject.seeded(null);

  BehaviorSubject<bool> buttonActive = BehaviorSubject.seeded(false);

  final Ref ref;

  EditCalendarViewModel(this.ref);

  initForm() {}

  void checkNameValid() {
    if (nameController.value.text.isEmpty)
      validName.add(t.calendar.add.fields.name.errors.empty);
    else
      validName.add(null);

    checkButton();
  }

  void checkUrlValid() {
    final text = urlController.text;

    if (text.isEmpty)
      validUrl.add(t.calendar.add.fields.url.errors.empty);
    else if (Uri.tryParse(text) == null)
      validUrl.add(t.calendar.add.fields.url.errors.invalid);
    else if (getIt<Isar>().calendars.where().urlEqualTo(text).isNotEmptySync())
      validUrl.add(t.calendar.add.fields.url.errors.notUnique);
    else
      validUrl.add(null);

    checkButton();
  }

  void checkButton() {
    buttonActive.add(validName.value == null && validUrl.value == null);
  }

  void setColor(Color? color) => this.color.add(color);

  Future<void> addCalendar(BuildContext context) async {
    final calendar = Calendar(
      name: nameController.text,
      url: urlController.text,
      type: CalendarType.CUSTOM,
      color: color.value,
      isActive: true,
    );
    final isar = getIt<Isar>();
    await isar.writeTxn(() async {
      await isar.calendars.put(calendar);
    });
    if (context.mounted) context.pop();
    clear();
  }

  void clear() {
    nameController.clear();
    urlController.clear();
    color.add(null);
  }
}
