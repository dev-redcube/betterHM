import 'package:better_hm/services/api/api_service.dart';

class ApiSemesterStatus extends ApiService {
  static const url =
      "https://raw.githubusercontent.com/adriangeorgimmel/hm-dates-api/gh-pages/thisSemester/all.json";

// Future<List<SemesterEvent>> getEvents() async {
//   final response = await httpGet(url);
//   if (200 == response.statusCode) {
//     final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
//     //List<Canteen> canteens = json.map((e) => Canteen.fromJson(e)).toList();
//     //return canteens;
//   } else {
//     //throw ApiException(response: response);
//   }
// }
}
