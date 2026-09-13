import 'package:http/http.dart' as http;

class NaverApiClient {
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) async {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  }
}
