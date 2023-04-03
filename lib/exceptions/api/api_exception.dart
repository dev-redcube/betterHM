class ApiException implements Exception {
  final String? message;
  final int? statusCode;

  ApiException({this.message = 'Unknown Api error', this.statusCode});
}
