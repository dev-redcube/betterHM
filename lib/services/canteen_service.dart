import 'dart:developer';

import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/api/api_canteen.dart';
import 'package:better_hm/services/isar_service.dart';
import 'package:isar/isar.dart';

class CanteenService extends IsarService {
  Future<List<Canteen>> getCanteens() async {
    final isar = await db;
    final List<Canteen> canteens = await isar.canteens.where().findAll();
    if (canteens.isEmpty) {
      log("Fetching Canteens from Server...");
      final canteens = await ApiCanteen().getCanteens();
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
