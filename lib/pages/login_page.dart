import 'package:carros/pages/home_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../widgets/app_text.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
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
            AppText('Login', 'Digite o login',
              controller: _tLogin,
              validator: _validateLogin,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              nextFocus: _focusSenha,
            ),
            SizedBox(height: 10),
            AppText('Senha', 'Digite a senha',
              password: true,
              controller: _tSenha,
              validator: _validateSenha,
              keyboardType: TextInputType.number,
              focusNode: _focusSenha,
            ),
            SizedBox(height: 20),
            AppButton('Login', _onClickLogin)
          ],
        ),
      ),
    );
  }

  _onClickLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tSenha.text;

    print('Login: $login, Senha: $senha');

    push(context, HomePage());
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
      return 'A senha precisa ter pelo menos 3 caracteres';
    }
    return null;
  }

  @override
  dispose() {
    super.dispose();
  }
}

