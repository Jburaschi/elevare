import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiClient {
  final _base = AppConfig.baseUrl;

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {String? token}) async {
    final uri = Uri.parse('$_base$path');
    final res = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    if (res.statusCode >= 200 && res.statusCode < 300 && res.body.isNotEmpty) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode >= 200 && res.statusCode < 300) {
      return {};
    } else {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final uri = Uri.parse('$_base$path');
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    if (res.statusCode >= 200 && res.statusCode < 300 && res.body.isNotEmpty) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode >= 200 && res.statusCode < 300) {
      return {};
    } else {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body, {String? token}) async {
    final uri = Uri.parse('$_base$path');
    final res = await http.put(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    if (res.statusCode >= 200 && res.statusCode < 300 && res.body.isNotEmpty) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode >= 200 && res.statusCode < 300) {
      return {};
    } else {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> delete(String path, {String? token}) async {
    final uri = Uri.parse('$_base$path');
    final res = await http.delete(uri, headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }
}
