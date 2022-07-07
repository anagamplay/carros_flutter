import 'dart:async';

import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:http/http.dart' as http;

class LoripsumBloc extends SimpleBloc<String> {

  static String? lorim;

  fetch() async{
    try {
      String s = lorim ?? await LoripsumApi.getLoripsum();

      lorim = s;

      add(s);
    } catch(e) {
      addError(e);
    }
  }
}

class LoripsumApi {
  static Future<String> getLoripsum() async {
    var url = Uri.parse('https://loripsum.net/api');

    print('GET > $url');

    var response = await http.get(url);

    String text = response.body;

    text = text.replaceAll('<p>', '');
    text = text.replaceAll('</p>', '');

    return text;
  }
}