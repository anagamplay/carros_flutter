import 'package:carros/main.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';

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

    favoritosBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: favoritosBloc.stream,
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

        List<Carro> carros = snapshot.data as List<Carro>;

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CarrosListView(carros),
        );
        }
    );
  }

  Future<void> _onRefresh() {
    return favoritosBloc.fetch();
  }
}
