// Custom ApiException class to represent API-related failures
class ApiException implements Exception {
  final int statusCode;
  final String errorMessage;

  ApiException(this.statusCode, this.errorMessage);

  @override
  String toString() {
    return 'ApiException: Status $statusCode - $errorMessage';
  }
}
