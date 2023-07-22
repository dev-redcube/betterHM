import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/service/api_canteen.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

class CanteenService {
  static const showCanteens = [
    "MENSA_ARCISSTR",
    "MENSA_GARCHING",
    "MENSA_LEOPOLDSTR",
    "MENSA_LOTHSTR",
    "MENSA_MARTINSRIED",
    "MENSA_PASING",
    "MENSA_WEIHENSTEPHAN",
    "STUBISTRO_ARCISSTR",
    "STUBISTRO_GOETHESTR",
    "STUBISTRO_GROSSHADERN",
    "STUBISTRO_ROSENHEIM",
    "STUBISTRO_SCHELLINGSTR",
    "STUBISTRO_MARTINSRIED",
    "STUCAFE_ADALBERTSTR",
    "STUCAFE_AKADEMIE_WEIHENSTEPHAN",
    "STUCAFE_CONNOLLYSTR",
    "STUCAFE_GARCHING",
    "STUCAFE_KARLSTR",
    "MENSA_STRAUBING",
  ];
  final Logger _log = Logger("CanteenService");

  static const loggerTag = "canteen service";

  Future<List<Canteen>> getCanteens() async {
    final isar = Isar.getInstance()!;
    final List<Canteen> canteens = await isar.canteens.where().findAll();
    if (canteens.isEmpty) {
      _log.info("Cache is Empty. Fetching Canteens from Server...");
      var canteens = await ApiCanteen().getCanteens();

      // filter and sort
      canteens = canteens
          .where((element) => showCanteens.contains(element.enumName))
          .toList();
      canteens
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      Canteen lothstr =
          canteens.firstWhere((element) => element.enumName == "MENSA_LOTHSTR");
      canteens.removeWhere((element) => element.enumName == "MENSA_LOTHSTR");
      canteens.insert(0, lothstr);

      storeCanteens(canteens);
      return canteens;
    }
    return canteens;
  }

  storeCanteens(List<Canteen> canteens, {bool clear = true}) async {
    final isar = Isar.getInstance()!;
    await isar.writeTxn(() async {
      if (clear) {
        await isar.canteens.clear();
      }
      await isar.canteens.putAll(canteens);
    });
  }

  clearCanteens() async {
    final isar = Isar.getInstance()!;
    await isar.writeTxn(() => isar.canteens.clear());
  }
}
