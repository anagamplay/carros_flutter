import 'package:carros/dropdown/dropdown.dart';
import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {

  Cor cor = Cor("Azul", Colors.blue);

  static final items = [
    Cor("Azul", Colors.blue),
    Cor("Amarelo", Colors.yellow),
    Cor("Verde", Colors.green),
    Cor("Vermelho", Colors.red),
    Cor("Preto", Colors.black)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: _body(),
    );
  }

  _body() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Text(
                  'Cor do Tema:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    DropDown<Cor>(items, "Cores", cor, _onCorChanged, cor.color),
                    Text(
                      cor != null ? "Cor > ${cor.nome}" : "",
                      style: TextStyle(color: cor.color,),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onCorChanged(Cor cor) {
    print("> ${cor.nome}");

    setState(() {
      this.cor = cor;
    });
  }
}

class Cor extends DropDownItem {
  Color color;
  String nome;

  Cor(this.nome, this.color);

  @override
  text() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(nome),
        Icon(Icons.circle, color: color),
      ],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Cor &&
              runtimeType == other.runtimeType &&
              nome == other.nome;

  @override
  int get hashCode => nome.hashCode;
}
