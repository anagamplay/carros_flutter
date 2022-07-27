import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FavoritosPage extends StatefulWidget {
  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Stream<QuerySnapshot> _favoritosStream = FirebaseFirestore.instance.collection('carros').snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _favoritosStream,
        builder: (context, snapshot,) {
          if (snapshot.hasError) {
            return TextError('[ERRO]Não foi possível buscar os carros');
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Carro> carros = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Carro.fromMap(data);
          }).toList();

          return CarrosListView(carros);
        }
    );
  }
}
