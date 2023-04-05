import 'dart:convert';

import 'package:better_hm/exceptions/api/api_exception.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/api/api_service.dart';

class ApiCanteen extends ApiService {
  static const baseUrl = "https://tum-dev.github.io/eat-api";

  Future<List<Canteen>> getCanteens() async {
    final response = await httpGet("$baseUrl/enums/canteens.json");
    if (200 == response.statusCode) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      List<Canteen> canteens = json.map((e) => Canteen.fromJson(e)).toList();
      return canteens;
    } else {
      throw ApiException(response: response);
    }
  }
}
