import 'dart:async';
import 'package:http/http.dart' as http;

class Interceptor extends http.BaseClient {
  final http.Client _httpClient = http.Client();
  late StreamController<int> _streamController;

  Interceptor() {
    _streamController = StreamController<int>.broadcast();
  }

  Stream<int> get responseStream => _streamController.stream;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    print('Request Method: ${request.method}');
    print('Request URL: ${request.url}');
    print('Request Headers: ${request.headers}');
    // Check if request body is not null
    if (request is http.Request) {
      print('Request Body: ${(request as http.Request).body}');
    } else if (request is http.MultipartRequest) {
      print('Request Body: MultipartRequest');
    } else {
      print('Request Body: None');
    }
    // Notify listeners that a request is being sent
    _streamController.add(request.hashCode);
    // Proceed with the request using the inner HTTP client
    final response = await _httpClient.send(request);
    // Print the response status code
    print('Response Status Code: ${response.statusCode}');
    // Return the response
    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
