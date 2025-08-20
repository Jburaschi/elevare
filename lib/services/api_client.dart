import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');

class ApiClient {
  final _client = http.Client();

  Uri _u(String path, [Map<String, dynamic>? q]) {
    final url = baseUrl.isNotEmpty ? baseUrl : 'http://localhost:3000';
    return Uri.parse('$url$path').replace(queryParameters: q?.map((k, v) => MapEntry(k, '$v')));
  }

  Future<Map<String, dynamic>> getJson(String path, {Map<String, dynamic>? query}) async {
    final r = await _client.get(_u(path, query), headers: {'Content-Type': 'application/json'});
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('GET $path -> ${r.statusCode}');
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final r = await _client.post(_u(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('POST $path -> ${r.statusCode}');
  }
}
