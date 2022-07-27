import 'dart:async';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/login_api.dart';
import 'package:carros/utils/simple_bloc.dart';

class LoginBloc extends BooleanBloc{

  Future<ApiResponse> login(login, senha) async {
    add(true);

    ApiResponse response = await LoginApi.login(login, senha);

    add(false);

    return response;
  }
}