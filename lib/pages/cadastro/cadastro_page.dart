import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _tNome = TextEditingController();
  final _tEmail = TextEditingController();
  final _tSenha = TextEditingController();
  //final _tConfirmeSenha = TextEditingController();

  final _focusNome = FocusNode();
  final _focusEmail = FocusNode();
  final _focusSenha = FocusNode();
  //final _focusConfirmeSenha = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
              'Nome',
              'Digite seu nome',
              controller: _tNome,
              validator: _validateNome,
              textInputAction: TextInputAction.next,
              nextFocus: _focusEmail,
              focusNode: _focusNome,
            ),
            SizedBox(height: 10),
            AppText(
              'Email',
              'Digite seu email',
              controller: _tEmail,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              nextFocus: _focusSenha,
              focusNode: _focusEmail,
            ),
            SizedBox(height: 10),
            AppText(
              'Senha',
              'Digite uma senha',
              controller: _tSenha,
              password: true,
              validator: _validateSenha,
              textInputAction: TextInputAction.next,
              //nextFocus: _focusConfirmeSenha,
              focusNode: _focusSenha,
            ),
            /*SizedBox(height: 10),
            AppText(
              'Confirme a senha',
              'Digite a senha novamente',
              password: true,
              controller: _tConfirmeSenha,
              validator: _validateConfirmeSenha,
              textInputAction: TextInputAction.done,
              focusNode: _focusConfirmeSenha,
            ),*/
            SizedBox(height: 20),
            StreamBuilder<bool>(
              builder: (context, snapshot) {
                return AppButton(
                  'Cadastrar',
                  onPressed: () => _onClickCadastrar(context),
                  showProgress: snapshot.data ?? false,
                );
              }
            ),
            SizedBox(height: 20),
            StreamBuilder<bool>(
                builder: (context, snapshot) {
                  return AppButton(
                    'Cancelar',
                    boxColor: Colors.red,
                    onPressed: () => _onClickCancelar(context),
                    showProgress: snapshot.data ?? false,
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  String? _validateNome(String? text) {
    if (text!.isEmpty) {
      return 'Digite seu nome';
    }
    return null;
  }

  String? _validateEmail(String? text) {
    if (text!.isEmpty) {
      return "Informe o email";
    }

    return null;
  }

  String? _validateSenha(String? text) {
    if (text!.isEmpty) {
      return "Informe a senha";
    }
    if (text.length <= 2) {
      return "Senha precisa ter mais de 2 números";
    }

    return null;
  }

  /*String? _validateConfirmeSenha(String? value) {
  }*/

  _onClickCadastrar(context) async {
    print('Cadastrar');

    String nome = _tNome.text;
    String email = _tEmail.text;
    String senha = _tSenha.text;
    //String confimeSenha = _tConfirmeSenha.text;

    print('Nome: $nome, Email: $email, Senha: $senha');

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final service = FirebaseService();
    final response = await service.cadastrar(nome, email, senha);

    if(response.ok == true) {
      push(context, HomePage(), replace: true,);
    } else {
      alert(context, response.msg);
    }

    setState(() {
      _progress = false;
    });
  }

  _onClickCancelar(context) {
    push(context, LoginPage(), replace: true,);
  }
}
