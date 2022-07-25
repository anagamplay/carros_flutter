import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _data;

  Future<ApiResponse> login(email, senha) async {
    try {
      // Login no Firebase
      var result = await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final fUser = result.user;
      print("Firebase Nome: ${fUser!.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");

      // Cria um usuario do app
      final user = Usuario(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoURL,
      );
      user.save();

      // Resposta genérica
      return ApiResponse.ok();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {
      // Login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      print("Google User: ${googleUser.email}");

      // Credenciais para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login no Firebase
      var result = await _auth.signInWithCredential(credential);
      final fUser = result.user;
      print("Firebase Nome: ${fUser!.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");

      // Cria um usuario do app
      final user = Usuario(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoURL,
      );
      user.save();

      // Resposta genérica
      return ApiResponse.ok();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> cadastrar(String nome, String email, String senha) async {
    try {
      // Usuario do Firebase
      var result = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      var fUser = result.user;
      print("Firebase Nome: ${fUser?.displayName}");
      print("Firebase Email: ${fUser?.email}");
      print("Firebase Foto: ${fUser?.photoURL}");

      // Dados para atualizar o usuário
      fUser?.updateDisplayName(nome);
      fUser?.updatePhotoURL("https://s3-sa-east-1.amazonaws.com/livetouch-temp/livrows/foto.png");

      print("Firebase Nome: ${fUser?.displayName}");
      print("Firebase Email: ${fUser?.email}");
      print("Firebase Foto: ${fUser?.photoURL}");

      // Resposta genérica
      return ApiResponse.ok(msg:"Usuário criado com sucesso");
    } catch (error) {
      print(error);

      if(error is PlatformException) {
        print("Error Code ${error.code}");

        return ApiResponse.error(msg: "Erro ao criar um usuário.\n\n${error.message}");
      }

      return ApiResponse.error(msg: "Não foi possível criar um usuário.");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}