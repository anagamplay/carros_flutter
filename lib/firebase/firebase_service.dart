import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

String? firebaseUserUid;

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

      saveUser(fUser);

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

      saveUser(fUser);

      // Resposta genérica
      return ApiResponse.ok();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  // Salva o usuario na colletion de usuarios logados
  void saveUser(User fUser) {
    if (fUser != null) {
      var firebaseUserUid = fUser.uid;
      DocumentReference refUser = FirebaseFirestore.instance.collection('users').doc(firebaseUserUid);
      refUser.set({
        'nome': fUser.displayName,
        'email': fUser.email,
        'login': fUser.email,
        'urlFoto': fUser.photoURL,
      });
    }
  }

  Future<ApiResponse> cadastrar(String nome, String email, String senha) async {
    try {
      //Cria um usuario
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);

      User? fUser = _auth.currentUser;

      fUser!.updateDisplayName(nome); //Opcional
      fUser.updatePhotoURL('https://cdn-icons-png.flaticon.com/512/149/149071.png');

      final usuario = Usuario(
        login: fUser.email,
        nome: nome,
        email: fUser.email,
        urlFoto: "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        token: fUser.uid,
      );
      usuario.save();

      saveUser(fUser);

      print("Firebase Nome: ${usuario.nome}");
      print("Firebase Email: ${usuario.email}");
      print("Firebase Foto: ${usuario.urlFoto}");

      return ApiResponse.ok(msg:"Usuário criado com sucesso!");
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