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

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('carros').snapshots(),
        builder: (
            context,
            snapshot,
            ) {
          if (snapshot.hasError) {
            return TextError('[ERRO]Não foi possível buscar os carros');
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Carro> carros = snapshot.data!.docs.map((DocumentSnapshot document) {
            return Carro.fromMap(document.data as Map<String, dynamic>);
          }).toList();

          return CarrosListView(carros);
        }
    );
  }
}
