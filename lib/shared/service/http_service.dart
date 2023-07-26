import 'package:http/http.dart' as http;

class HttpService {
  static final HttpService _instance = HttpService._internal();

  factory HttpService() => _instance;

  late final http.Client client;

  HttpService._internal() {
    client = http.Client();
  }
}
