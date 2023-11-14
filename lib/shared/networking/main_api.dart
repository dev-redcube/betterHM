import 'dart:convert';
import 'dart:developer';

import 'package:better_hm/shared/exceptions/api/api_exception.dart';
import 'package:better_hm/shared/networking/api.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'api_response.dart';

class MainApi {
  late Dio dio;
  MemCacheStore? memCacheStore;

  MainApi.cache() {
    final memCacheStore = MemCacheStore();
    final cacheOptions = CacheOptions(
      store: memCacheStore,
      policy: CachePolicy.forceCache,
      maxStale: const Duration(days: 1),
      hitCacheOnErrorExcept: [401, 404],
    );

    final dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: cacheOptions));
    dio.options = BaseOptions(
      responseDecoder: (data, options, body) {
        final decoded = utf8.decoder.convert(data);
        return decoded;
      },
    );

    this.dio = dio;
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

    log("${response.statusCode}: ${response.realUri}");
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
    T Function(Map<String, dynamic>) createObject, [
    Options? options,
    bool forcedRefresh = false,
  ]) async {
    Response<String> response;

    if (forcedRefresh) {
      Dio noCacheDio = Dio()..interceptors.addAll(dio.interceptors);
      noCacheDio.options.responseDecoder = dio.options.responseDecoder;
      noCacheDio.options.extra["forcedRefresh"] = "true";
      response = await noCacheDio.getUri(endpoint, options: options);
    } else {
      response = await dio.getUri(endpoint, options: options);
    }

    log("${response.statusCode}: ${response.realUri}");

    return ApiResponse<T>.fromJson(
      jsonDecode(response.data.toString()),
      response.headers,
      createObject,
    );
  }

  clearCache() async {
    if (memCacheStore != null) memCacheStore!.clean();
  }
}
