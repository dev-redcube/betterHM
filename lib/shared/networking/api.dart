import 'package:dio/dio.dart' as dio;

abstract class Api {
  String get baseUrl;

  String get path;

  Map<String, String> get baseHeaders => {};

  String get paths;

  Map<String, String> get parameters;

  Future<dio.Response<String>> asResponse({required dio.Dio dioClient}) async {
    final uri = Uri.https(baseUrl, paths, parameters);
    return dioClient.getUri(uri, options: _customDecodingOptions(baseHeaders));
  }

  dio.Options _customDecodingOptions(Map<String, String> headers) =>
      dio.Options(headers: headers);

  @override
  String toString() => baseUrl + path + paths;
}
