import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/isar_service.dart';
import 'package:isar/isar.dart';

class CacheCanteenService extends IsarService {
  Future<List<Canteen>?> getCanteens() async {
    final isar = await db;
    return await isar.canteens.where().findAll();
  }

  storeCanteens(List<Canteen> canteens) async {
    final isar = await db;
  }
}
