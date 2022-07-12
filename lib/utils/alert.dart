import 'package:flutter/material.dart';

alert(context, msg, {Function? callback}) {
  showDialog(
    barrierDismissible: false, // Para não fechar quando clicar fora
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false, // Se apertar no botao de voltar nao fecha
        child: AlertDialog(
          title: const Text('Carros'),
          content: Text(msg ?? 'ERRO!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                if(callback != null) {
                  callback();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}