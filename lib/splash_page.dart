import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Future<User?> currentUser() async {
    final fUser = await FirebaseAuth.instance.currentUser;
    return fUser;
  }

  @override
  void initState() {
    // Inicializar o banco de dados
    Future futureA = DatabaseHelper.getInstance().db;

    Future futureB = Future.delayed(Duration(seconds: 3),);

    // Pega o usuario logado
    Future futureC = currentUser();

    Future.wait([futureA, futureB, futureC]).then((List values){
      User? fUser = values[2];
      print(fUser);

      if(fUser != null) {
        firebaseUserUid = fUser.uid;

        push(context, HomePage(), replace: true);
      } else {
        push(context, LoginPage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
