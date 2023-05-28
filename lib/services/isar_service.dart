import 'package:better_hm/models/dashboard/event.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

abstract class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      await Isar.open([CanteenSchema, EventSchema], inspector: false, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }
}
