import 'dart:convert';

import 'package:better_hm/exceptions/api/api_connection_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';

class ApiService {
  Map<String, String> get headers => {};

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    http.Response response = await http.get(Uri.parse(url),
        headers: this.headers..addAll(headers ?? {}));
    return response;
  }

  Future httpGet(String url) async {
    Request request = prepareRequest('get', url);
    return sendRequest(request);
  }

  Map<String, String> getHeaders({bool? withoutToken}) {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'charset': 'UTF-8'
    };

    return headers;
  }

  Request prepareRequest(String method, String url,
      {Map<String, dynamic>? jsonBody, bool? withoutToken}) {
    Map<String, String> headers = getHeaders(withoutToken: withoutToken);

    Request request = Request(method, Uri.parse(url));

    request.headers.addAll(headers);

    if (jsonBody != null) {
      request.body = jsonEncode(jsonBody);
    }

    return request;
  }

  Future sendRequest(BaseRequest request) async {
    try {
      Response response = await Response.fromStream(await request.send());

      return response;
    } catch (e) {
      // On connection issue, save request to queue and retry later. Exclude get requests
      // @todo handle image
      if (request.method != 'get' && request is Request) {
        Workmanager().registerOneOffTask(
            'retryFailedRequestTask', 'retryFailedRequestTask',
            inputData: {
              'method': request.method,
              'url': request.url.toString(),
              'jsonBody': (request.body != '') ? request.body : null
            },
            constraints: Constraints(networkType: NetworkType.connected),
            existingWorkPolicy: ExistingWorkPolicy.append,
            initialDelay: const Duration(minutes: 1));
      }

      throw ApiConnectionException();
    }
  }

  Future retryRequest(Map<String, dynamic> requestData) async {
    Map<String, String> headers = getHeaders();

    // Build and retry request
    Request request =
        Request(requestData['method'], Uri.parse(requestData['url']));
    request.headers.addAll(headers);

    if (requestData['jsonBody'] != null) {
      request.body = requestData['jsonBody'];
    }

    try {
      await sendRequest(request);
    } catch (e) {
      // Ignore error
    }
  }
}
