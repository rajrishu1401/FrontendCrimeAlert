import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api"; // for Android emulator

  static Future<Map<String, dynamic>> login(String userId, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userId": userId,
        "password": password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      print("response: $body");
      return body;
    } else {
      print("error: $body");
      throw Exception(body['message']);
    }
  }


}
