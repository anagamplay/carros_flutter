import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_bloc.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  String tipo;

  CarrosPage(this.tipo, {Key? key}) : super(key: key);

  @override
  State<CarrosPage> createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  List<Carro>? carros;

  final _bloc = CarrosBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _bloc.fetch(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: _bloc.stream,
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
    return _bloc.fetch(widget.tipo);
  }

  @override
  dispose() {
    super.dispose();

    _bloc.dispose();
  }
}
