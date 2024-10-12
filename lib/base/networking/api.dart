import 'package:dio/dio.dart' as dio;

abstract class Api {
  String get baseURL;

  String get path => "";

  Map<String, String> get baseHeaders => {};

  String get paths;

  Map<String, String> get parameters => {};

  Future<dio.Response<String>> get({required dio.Dio dioClient}) async =>
      dioClient.getUri(
        asURL(),
        options: _customDecodingOptions(baseHeaders),
      );

  Uri asURL() => Uri.https(baseURL, paths, parameters);

  dio.Options _customDecodingOptions(Map<String, String> headers) =>
      dio.Options(headers: headers);

  @override
  String toString() => baseURL + path + paths;
}
