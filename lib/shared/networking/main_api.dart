import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:logging/logging.dart';
import 'package:redcube_campus/shared/exceptions/api/api_exception.dart';
import 'package:redcube_campus/shared/networking/api.dart';

import 'api_response.dart';

// https://stackoverflow.com/questions/67249487/how-do-i-implement-dio-http-cache-alongside-my-interceptor
class MainApi {
  late Dio dio;
  late Dio noCacheDio;
  MemCacheStore? memCacheStore;
  final _logger = Logger("MainApi");

  MainApi.cache() {
    final memCacheStore = MemCacheStore();
    final cacheOptions = CacheOptions(
      store: memCacheStore,
      policy: CachePolicy.forceCache,
      maxStale: const Duration(hours: 1),
    );

    final dio =
        Dio()..interceptors.add(DioCacheInterceptor(options: cacheOptions));
    dio.options = BaseOptions(
      responseDecoder: (data, options, body) {
        final decoded = utf8.decoder.convert(data);
        return decoded;
      },
    );

    this.dio = dio;

    noCacheDio = Dio();
    noCacheDio.options = BaseOptions(
      responseDecoder: (data, options, body) {
        final decoded = utf8.decoder.convert(data);
        return decoded;
      },
    );
  }

  Future<ApiResponse<T>>
  makeRequestWithException<T, S extends Api, U extends ApiException>(
    S endpoint,
    dynamic Function(Map<String, dynamic>) createObject,
    dynamic Function(Map<String, dynamic>) createError,
    bool forcedRefresh,
  ) async {
    Response<String> response;
    if (forcedRefresh) {
      Dio noCacheDio = Dio()..interceptors.addAll(dio.interceptors);
      noCacheDio.options.responseDecoder = dio.options.responseDecoder;
      noCacheDio.options.extra["forcedRefresh"] = true;
      response = await endpoint.asResponse(dioClient: noCacheDio);
    } else {
      response = await endpoint.asResponse(dioClient: dio);
    }

    _logger.info("${response.statusCode}: ${response.realUri}");
    try {
      throw ApiResponse<U>.fromJson(
        jsonDecode(response.data.toString()),
        response.headers,
        createError,
      ).data;
    } on U catch (e) {
      e.toString();
      rethrow;
    } catch (_) {
      return ApiResponse<T>.fromJson(
        jsonDecode(response.data.toString()),
        response.headers,
        createObject,
      );
    }
  }

  Future<ApiResponse<T>> get<T>(
    Uri endpoint,
    T Function(Map<String, dynamic>) createObject, {
    Options? options,
    bool forcedRefresh = false,
  }) async {
    Response<String> response;

    if (forcedRefresh) {
      Dio noCacheDio = Dio()..interceptors.addAll(dio.interceptors);
      noCacheDio.options.responseDecoder = dio.options.responseDecoder;
      noCacheDio.options.extra["forcedRefresh"] = "true";
      response = await noCacheDio.getUri(endpoint, options: options);
    } else {
      response = await dio.getUri(endpoint, options: options);
    }

    _logger.info("${response.statusCode}: ${response.realUri}");

    return ApiResponse<T>.fromJson(
      jsonDecode(response.data.toString()),
      response.headers,
      createObject,
    );
  }

  Future<ApiResponse<T>> getNeverCache<T>(
    Uri endpoint,
    T Function(Map<String, dynamic>) createObject, {
    Options? options,
  }) async {
    Response<String> response;

    response = await noCacheDio.getUri(endpoint, options: options);

    _logger.info("${response.statusCode}: ${response.realUri}");

    return ApiResponse<T>.fromJson(
      jsonDecode(response.data.toString()),
      response.headers,
      createObject,
    );
  }

  Future<ApiResponse<String>> getRawString(
    Uri endpoint, {
    Options? options,
  }) async {
    Response<String> response;
    response = await dio.getUri(endpoint, options: options);
    return ApiResponse<String>(data: response.data.toString());
  }

  clearCache() async {
    if (memCacheStore != null) memCacheStore!.clean();
  }
}
