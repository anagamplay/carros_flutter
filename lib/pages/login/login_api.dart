import 'dart:convert';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<ApiResponse<Usuario>> login(login, senha) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map params = {
        'username': login,
        'password': senha,
      };

      String s = json.encode(params);
      print(">> $s");


      var url = Uri.parse('https://carros-springboot.herokuapp.com/api/v2/login');

      var response = await http.post(url, body: s, headers: headers,);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = Usuario.fromJson(mapResponse);

        user.save();

        return ApiResponse.ok(result: user);
      }

      return ApiResponse.error(msg: mapResponse['error']);
    } catch(error, excepition) {
        print('Erro no login $error > $excepition');
        
        return ApiResponse.error(msg: 'Não foi possível fazer o login');
    }
  }
}
