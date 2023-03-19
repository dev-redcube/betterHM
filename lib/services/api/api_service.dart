import 'package:http/http.dart' as http;

class ApiService {
  Map<String, String> get headers => {};

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    http.Response response = await http.get(Uri.parse(url),
        headers: this.headers..addAll(headers ?? {}));
    return response;
  }
}
