import 'package:http/http.dart';

class ApiException implements Exception {
  final String? message;
  final Response? response;

  ApiException({this.message = 'Unknown Api error', this.response});

  @override
  String toString() {
    if (response != null) {
      return "API Error ${response!.statusCode}: ${response!.body}";
    } else if (message != null) {
      return "API Error: $message";
    }
    return "Unknown API Error";
  }
}
