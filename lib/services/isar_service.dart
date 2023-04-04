import 'package:better_hm/models/meal/canteen.dart';
import 'package:isar/isar.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      await Isar.open([CanteenSchema], inspector: true);
    }

    return Future.value(Isar.getInstance());
  }
}
