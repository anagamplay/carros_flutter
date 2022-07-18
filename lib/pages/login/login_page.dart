import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/cadastro_page.dart';
import 'package:carros/pages/login/login_bloc.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../widgets/app_text.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = LoginBloc();
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final _focusSenha = FocusNode();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carros'),
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            AppText(
              'Login',
              'Digite o login',
              controller: _tLogin,
              validator: _validateLogin,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              nextFocus: _focusSenha,
            ),
            SizedBox(height: 10),
            AppText(
              'Senha',
              'Digite a senha',
              password: true,
              controller: _tSenha,
              validator: _validateSenha,
              focusNode: _focusSenha,
            ),
            SizedBox(height: 20),
            StreamBuilder<bool>(
              stream: _bloc.stream,
              //initialData: false,
              builder: (context, snapshot) {
                return AppButton(
                  'Login',
                  onPressed: _onClickLogin,
                  showProgress: snapshot.data ?? false,
                );
              }
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SignInButton(
                Buttons.GoogleDark,
                padding: EdgeInsets.all(7),
                onPressed: _onClickGoolge,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: _onClickCadastrar,
                child: Text(
                  'Cadastre-se',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onClickLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tSenha.text;

    print('Login: $login, Senha: $senha');

    ApiResponse response = await _bloc.login(login, senha);

    if (response.ok == true) {
      Usuario? user = response.result;
      print('>>> $user');
      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.msg);
    }
  }

  String? _validateLogin(String? text) {
    if (text!.isEmpty) {
      return 'Digite o login';
    }
    return null;
  }

  String? _validateSenha(String? text) {
    if (text!.isEmpty) {
      return 'Digite a senha';
    }
    if (text.length < 3) {
      return 'A senha precisa ter pelo menos 3 números';
    }
    return null;
  }

  @override
  dispose() {
    super.dispose();

    _bloc.dispose();
  }

  _onClickGoolge() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();

    if (response.ok == true) {
      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.msg);
    }
  }

  void _onClickCadastrar() {
    push(context, CadastroPage(), replace: true);
  }
}
