import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarroFormPage extends StatefulWidget {
  final Carro? carro;

  CarroFormPage({this.carro});

  @override
  State<CarroFormPage> createState() => _CarroFormPageState();
}

class _CarroFormPageState extends State<CarroFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tDesc = TextEditingController();
  final tTipo = TextEditingController();

  int _radioIndex = 0;

  var _showProgress = false;

  File? _file;

  Carro? get carro => widget.carro;

  @override
  void initState() {
    super.initState();

    // Copia os dados do carro para o form
    final carro = this.carro;
    if (carro != null) {
      tNome.text = carro.nome;
      tDesc.text = carro.descricao ?? "";
      _radioIndex = getTipoInt(carro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro != null ? carro!.nome : 'Novo Carro'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _headerFoto(),
          InkWell(
            onTap: onCLickFoto,
            child: Text('Clique para adicionar imagem',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(),
          SizedBox(height: 45),
          AppText(
            "Nome",
            "",
            controller: tNome,
            keyboardType: TextInputType.text,
            validator: _validateNome as String? Function(String?),
          ),
          SizedBox(height: 25),
          AppText(
            "Descrição",
            "",
            controller: tDesc,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 25),
          _radioTipo(),
          SizedBox(height: 35),
          AppButton(
            "Salvar",
            onPressed: _onClickSalvar,
            showProgress: _showProgress,
            backgroundColor: Colors.blue,
          )
        ],
      ),
    );
  }

  _headerFoto() {
    return InkWell(
      onTap: onCLickFoto,
      child: _file != null
        ? Image.file(
            _file!,
            height: 150,)
        : carro != null && carro?.urlFoto != null
        ? CachedNetworkImage(
            imageUrl: carro?.urlFoto ?? "https://s3-sa-east-1.amazonaws.com/videos.livetouchdev.com.br/esportivos/Maserati_Grancabrio_Sport.png",
            height: 150,)
        : Image.asset(
            "assets/images/camera.png",
            height: 150,),
    );
  }

  _radioTipo() {
    return Row(
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Clássicos",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Esportivos",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Luxo",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ],
    );
  }

  void _onClickTipo(int? value) {
    setState(() {
      _radioIndex = value!;
    });
  }

  getTipoInt(Carro carro) {
    switch (carro.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  void onCLickFoto() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    print('File: $image');

    if(image != null) {
      setState(() {
        _file = File(image.path);
      });
    }
  }

  // Add validate email function.
  String? _validateNome(value) {
    if (value.isEmpty) {
      return 'Informe o nome do carro.';
    }
    return null;
  }

  _onClickSalvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Cria o carro
    var c = carro ?? Carro();

    c.nome = tNome.text;

    if(tDesc.text != null) {
      c.descricao = tDesc.text;
    } else {
      c.descricao = "";
    }

    c.tipo = _getTipo();

    print("Carro: $c");

    setState(() {
      _showProgress = true;
    });

    print("Salvar o carro $c");

    ApiResponse<bool> response = await CarrosApi.save(c, _file);

    if(response.ok == true) {
      alert(context, "Carro salvo com sucesso!", callback: (){Navigator.pop(context);},);
    } else {
      alert(context, response.msg,);
    }

    setState(() {
      _showProgress = false;
    });

    print("Fim.");
  }
}