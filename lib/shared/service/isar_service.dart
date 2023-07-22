import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/shared/logger/log_entry.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      await Isar.open([LogEntrySchema, CanteenSchema],
          directory: dir.path, inspector: false);
    }
    return Future.value(Isar.getInstance());
  }
}
