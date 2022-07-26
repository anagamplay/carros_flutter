import 'package:flutter/material.dart';

alert(context, msg, {Function? callback}) {
  showDialog(
    barrierDismissible: false, // Para nao fechar ao clicar fora do alerta
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false, // Para nao fechar ao voltar
        child: AlertDialog(
          title: const Text('Carros'),
          content: Text(msg),
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