import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Future<User?> currentUser() async {
    await FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {

    // Inicializar o banco de dados
    Future futureA = DatabaseHelper.getInstance().db;

    Future futureB = Future.delayed(Duration(seconds: 3),);

    Future futureC = currentUser();
    //Usuario

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

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc("docID")
        .get();
  }
}
