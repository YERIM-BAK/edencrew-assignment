import 'package:http/http.dart' as http;

class NaverApiClient {
  Future<http.Response> get(Uri uri) async {
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  }
}
