import 'package:carros/firebase.dart';
import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/cadastro/cadastro_page.dart';
import 'package:carros/pages/login/finger_print.dart';
import 'package:carros/pages/login/login_bloc.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/app_text.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fUser = FirebaseAuth.instance.currentUser;
  bool? biometrics;

  final _formKey = GlobalKey<FormState>();
  final _bloc = LoginBloc();

  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final _focusSenha = FocusNode();

  @override
  initState() {
    super.initState();

    _canCheckBiometrics();
    initFcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 200,),
                AppText(
                  'Login',
                  'Digite o login',
                  icon: Icons.account_circle,
                  controller: _tLogin,
                  validator: _validateLogin,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  nextFocus: _focusSenha,
                ),
                SizedBox(height: 25),
                AppText(
                  'Senha',
                  'Digite a senha',
                  icon: Icons.vpn_key,
                  password: true,
                  controller: _tSenha,
                  validator: _validateSenha,
                  focusNode: _focusSenha,
                ),
                SizedBox(height: 35),
                StreamBuilder<bool>(
                  stream: _bloc.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    return AppButton(
                      'Login',
                      onPressed: _onClickLogin,
                      showProgress: snapshot.data as bool,
                      backgroundColor: Colors.blue,
                    );
                  }
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: SignInButton(
                        Buttons.GoogleDark,
                        onPressed: _onClickGoolge,
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Não possui uma conta? ',),
                    GestureDetector(
                      onTap: _onClickCadastrar,
                      child: Text('Cadastre-se', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),),
                    )
                  ]
                ),
                SizedBox(height: 60),
                Opacity(
                  opacity: fUser != null && biometrics == true ? 1 : 0,
                  child: Container(
                    height: 46,
                    child: GestureDetector(
                      onTap: () => _onCLickFingerprint(context),
                      child: Image.asset('assets/images/fingerprint.png'),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  _onClickLogin() async {
    FocusScope.of(context).unfocus();

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
      alert(context, 'Login ou senha inválidos');
    }
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
    _tLogin.clear();
    _tSenha.clear();
    push(context, CadastroPage());
  }

  String? _validateLogin(String? text) {
    if (text!.isEmpty) {
      return 'Informe o login';
    }
    return null;
  }

  String? _validateSenha(String? text) {
    if (text!.isEmpty) {
      return 'Informe a senha';
    }
    return null;
  }


  _canCheckBiometrics() async {
    print('Verificando biometria...');

    final canCheckBiometrics = await FingerPrint.canCheckBiometrics();

    if(canCheckBiometrics == true) {
      print('Biometria ok!');
      biometrics = true;
    }
    print('Biometria error');
    biometrics = false;
  }

  _onCLickFingerprint(BuildContext context) async {
    print('FingerPrint!');

    final ok = await FingerPrint.verify();

    if (ok == true) {
      print('Acesso liberado!');
      return push(context, HomePage());
    }
    print('Acesso negado!');
    return alert(context, 'Biometria inválida');
  }

  @override
  dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
