import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/upload_api.dart';
import 'package:carros/utils/http_helper.dart' as http;

class TipoCarro {
  static final String classicos = 'classicos';
  static final String esportivos = 'esportivos';
  static final String luxo = 'luxo';
}

class CarrosApi {
  static Future<List<Carro>> getCarros(String tipo, int page) async {

    if(page == 0) {
      tipo = "classicos";
    } else if(page == 1) {
      tipo = "esportivos";
    } else if(page == 2) {
      tipo = "luxo";
    } else {
      return [];
    }

    var url = Uri.parse('https://carros-springboot.herokuapp.com/api/v1/carros/tipo/$tipo');

    print("GET > $url");

    var response = await http.get(url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Carro> carros = list.map<Carro>((map) => Carro.fromMap(map)).toList();

    return carros;
  }

  static Future<ApiResponse<bool>> save(Carro c, File? file) async {
    try {

      if(file != null) {
        ApiResponse<String> response = await UploadApi.upload(file);
        if(response.ok == true) {
          String urlFoto = response.result as String;
          c.urlFoto = urlFoto;
        }
      }

      var url = Uri.parse('https://carros-springboot.herokuapp.com/api/v1/carros');

      if (c.id != null) {
        url = Uri.parse('https://carros-springboot.herokuapp.com/api/v1/carros/${c.id}');
      }

      print('POST > $url');

      String json = c.toJson();

      print("   JSON > $json");

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json)
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> mapResponse = convert.json.decode(response.body);

        Carro carro = Carro.fromMap(mapResponse);

        print("Novo carro: ${carro.id}");

        return ApiResponse.ok();
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error(msg: '[ERRO] Não foi possível salvar o carro');
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch(e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o carro");
    }
  }

  static Future<ApiResponse<bool>> delete(Carro c) async {
    try {

      var url = Uri.parse('https://carros-springboot.herokuapp.com/api/v1/carros/${c.id}');

      print('DELETE > $url');

      var response = await http.delete(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return ApiResponse.ok();
      }

      return ApiResponse.error(msg: "Não foi possível deletar o carro");
    } catch(e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível deletar o carro");
    }
  }
}