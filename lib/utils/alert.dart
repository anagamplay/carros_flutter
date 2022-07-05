import 'package:flutter/material.dart';

alert(context, msg) {
  showDialog(
    barrierDismissible: false, // Para não fechar quando clicar fora
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false, // Se apertar no botao de voltar nao fecha
        child: AlertDialog(
          title: const Text('Carros'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}