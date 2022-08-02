import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  String dropdownValue = 'One';

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
          color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'DropdownButton:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20,),
              _dropDown(),
            ],
          ),
        ),
      ],
    );
  }

  _dropDown() {
    return Flexible(
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        elevation: 16,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>['One', 'Two', 'Free', 'Four']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}