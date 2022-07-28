import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritoService {

   get _users => FirebaseFirestore.instance.collection("users");
   get _carros => _users.doc(firebaseUserUid).collection("favoritos");

   get stream => _carros.snapshots();

   Future<bool?> favoritar(Carro c) async {

      DocumentReference docRef = _carros.doc('${c.id}');

      DocumentSnapshot doc = await docRef.get();

      final exists = doc.exists;

      if(exists) {
         // Remove dos favoritos
         docRef.delete();

        return false;
      } else {
         // Adiciona nos favoritos
         docRef.set(c.toMap());

         return true;
      }
   }

   Future<bool> isFavorito(Carro c) async{

      DocumentReference docRef = _carros.doc('${c.id}');

      DocumentSnapshot doc = await docRef.get();

      final exists = doc.exists;

      return exists;
   }
}