import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/networking/main_api.dart';

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

  static Future<(DateTime?, List<Canteen>)> fetchCanteens(
    bool forcedRefresh,
  ) async {
    MainApi mainApi = getIt<MainApi>();

    final uri = Uri(
      scheme: "https",
      host: "tum-dev.github.io",
      path: "/eat-api/enums/canteens.json",
    );

    final response = await mainApi.get(uri, Canteens.fromJson);

    return (
      response.saved,
      response.data.canteens
          .where((element) => showCanteens.contains(element.enumName))
          .toList(),
    );
  }
}
