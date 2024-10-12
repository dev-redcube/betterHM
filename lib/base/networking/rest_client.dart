import 'dart:convert';

import 'package:better_hm/base/networking/api.dart';
import 'package:better_hm/base/networking/api_response.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class RestClient {
  late Dio dio;

  RestClient() {
    final dio = Dio();

    dio.options = BaseOptions(
      responseDecoder: (data, options, body) {
        final decoded = utf8.decoder.convert(data);
        return decoded;
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
    this.dio = dio;
  }

  Future<ApiResponse<T>> get<T, S extends Api>(
    S endpoint,
    dynamic Function(Map<String, dynamic>) createObject,
    bool forcedRefresh,
  ) async {
    Response<String> response;

    final log = Logger(endpoint.runtimeType.toString());

    try {
      if (forcedRefresh) {
        Dio noCacheDio = Dio()..interceptors.addAll(dio.interceptors);
        noCacheDio.options.responseDecoder = dio.options.responseDecoder;
        noCacheDio.options.extra["forcedRefresh"] = "true";
        response = await endpoint.get(dioClient: noCacheDio);
      } else {
        response = await endpoint.get(dioClient: dio);
      }

      log.info("${response.statusCode}: ${response.realUri}");

      return ApiResponse<T>.fromJson(
        jsonDecode(response.data.toString()),
        response.extra,
        createObject,
      );
    } catch (e) {
      if (e is Error)
        log.severe("${endpoint.asURL()}: ${e.stackTrace}");
      else
        log.warning("${endpoint.asURL()}: $e");
      rethrow;
    }
  }
}
