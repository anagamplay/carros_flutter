import 'dart:convert';

import 'package:carros/pages/api_responde.dart';
import 'package:carros/pages/usuario.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<ApiResponse<Usuario>> login(login, senha) async {
    Map<String, String> headers = {
      "Content-Type": "application/json"
    };

    Map params = {
      'username': login,
      'password': senha,
    };

    String s = json.encode(params);

    var url = Uri.parse('https://carros-springboot.herokuapp.com/api/v2/login');
    var response = await http.post(url, body: s, headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      final user = Usuario.fromJson(mapResponse);

      return ApiResponse.ok(user);
    }
    
    return ApiResponse.error(mapResponse['error']);
  }
}
