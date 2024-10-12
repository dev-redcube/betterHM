import 'package:better_hm/base/networking/api.dart';
import 'package:better_hm/homeComponent/models/station.dart';

class MvgApi extends Api {
  final Station station;
  final Duration offset;

  MvgApi({required this.station, Duration? offset})
      : offset = offset ?? const Duration(minutes: 1);

  @override
  String get baseURL => "www.mvg.de";

  @override
  Map<String, String> get parameters => {
        "globalId": station.id,
        "limit": "30",
        "offsetInMinutes": offset.inMinutes.toString(),
        "transportTypes": "UBAHN,TRAM,BUS,SBAHN",
      };

  @override
  String get paths => "/api/fib/v2/departure";
}
