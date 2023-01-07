import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_bloc.dart';
import 'package:carros/pages/carros/carros_listview.dart';
import 'package:carros/utils/event_bus.dart';
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
  StreamSubscription<Event>? subscription;

  String get tipo => widget.tipo;

  final _bloc = CarrosBloc();

  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _bloc.fetch(tipo);

    // Escutando um stream
    final bus = EventBus.get(context);
    subscription = bus.stream.listen((Event s) {
      print("Event $s");
      _bloc.fetch(tipo);
    }) as StreamSubscription<Event>?;

    // Fim do scroll, carrega mais
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("FIM!");
        _bloc.fetchMore(tipo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Carro> list = [];

    return StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError('[ERRO]Não foi possível buscar os carros');
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Carro> carros = snapshot.data as List<Carro>;

          list.addAll(carros);

          bool showProgress = carros.length > 0;
          // print("showProgress: $showProgress");

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CarrosListView(list, scrollController: _scrollController, showProgress: showProgress,),
          );
        });
  }

  Future<void> _onRefresh() {
    //print("Refresh");
    return _bloc.fetch(tipo);
  }

  @override
  dispose() {
    super.dispose();

    _bloc.dispose();
  }
}
