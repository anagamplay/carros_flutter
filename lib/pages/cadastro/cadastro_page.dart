import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
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
  final _tConfirmeSenha = TextEditingController();

  final _focusNome = FocusNode();
  final _focusEmail = FocusNode();
  final _focusSenha = FocusNode();
  final _focusConfirmeSenha = FocusNode();

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
                SizedBox(height: 200),
                AppText(
                  'Nome',
                  'Digite seu nome',
                  icon: Icons.account_circle,
                  controller: _tNome,
                  validator: _validateNome,
                  textInputAction: TextInputAction.next,
                  nextFocus: _focusEmail,
                  focusNode: _focusNome,
                ),
                SizedBox(height: 25),
                AppText(
                  'Email',
                  'Informe seu email',
                  icon: Icons.mail,
                  controller: _tEmail,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  nextFocus: _focusSenha,
                  focusNode: _focusEmail,
                ),
                SizedBox(height: 25),
                AppText(
                  'Senha',
                  'Digite uma senha',
                  icon: Icons.vpn_key,
                  controller: _tSenha,
                  password: true,
                  validator: _validateSenha,
                  textInputAction: TextInputAction.next,
                  //nextFocus: _focusConfirmeSenha,
                  focusNode: _focusSenha,
                ),
                SizedBox(height: 25),
                AppText(
                  'Confirme a senha',
                  'Confirme a senha',
                  icon: Icons.vpn_key,
                  password: true,
                  controller: _tConfirmeSenha,
                  validator: _validateConfirmeSenha,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusConfirmeSenha,
                ),
                SizedBox(height: 35),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => _onClickCadastrar(context),
                    child: _progress
                      ? Center(
                          child: Container(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
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
      return "Informe seu email";
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(text)) {
      return ("Email inválido");
    }

    return null;
  }

  String? _validateSenha(String? text) {
    if (text!.isEmpty) {
      return "Informe uma senha";
    }
    if (text.length <= 5) {
      return "Precisa ter no mínimo 6 caracteres";
    }
    if (_tConfirmeSenha.text.isNotEmpty) {
      if (text != _tConfirmeSenha.text) {
        return 'As senha não coincidem';
      }
    }

    return null;
  }

  String? _validateConfirmeSenha(String? text) {
    if (_tSenha.text.length >= 6) {
      if (text!.isEmpty) {
        return "Confirme a senha";
      }
      if (text != _tSenha.text) {
        return 'As senha não coincidem';
      }

      return null;
    }
  }

  _onClickCadastrar(context) async {
    print('Cadastrar');

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final service = FirebaseService();
    final response = await service.cadastrar(_tNome.text, _tEmail.text, _tSenha.text);

    if (response.ok == true) {
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.msg as String)));
      push(context, HomePage(), replace: true,);
    } else {
      alert(context, response.msg);
    }

    setState(() {
      _progress = false;
    });
  }
}
