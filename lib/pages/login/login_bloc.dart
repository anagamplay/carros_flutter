import 'dart:async';

import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/simple_bloc.dart';

class LoginBloc extends SimpleBloc<bool>{

  Future<ApiResponse> login(login, senha) async {
    add(true);

    // ApiResponse response = await LoginApi.login(login, senha);
    ApiResponse response = await FirebaseService().login(login, senha);

    add(false);

    return response;
  }
}