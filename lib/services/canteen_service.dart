import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/api/api_canteen.dart';
import 'package:better_hm/services/isar_service.dart';
import 'package:isar/isar.dart';

class CanteenService implements IsarService {
  @override
  late Future<Isar> db;

  CanteenService() {
    db = openDB();
  }

  @override
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      await Isar.open([CanteenSchema]);
    }

    return Future.value(Isar.getInstance());
  }

  Future<List<Canteen>> getCanteens() async {
    final isar = await db;
    final List<Canteen> canteens = await isar.canteens.where().findAll();
    if (canteens.isEmpty) {
      print("fetching...");
      final canteens = await ApiCanteen().getCanteens();
      print("fetched");
      storeCanteens(canteens);
      return canteens;
    }
    return canteens;
  }

  storeCanteens(List<Canteen> canteens, {bool clear = true}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      if (clear) {
        await isar.canteens.clear();
      }
      await isar.canteens.putAll(canteens);
    });
  }
}
