import 'dart:async';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/utils/simple_bloc.dart';

class CarrosBloc extends SimpleBloc<List<Carro>>{
  int _page = 0;

  Future<List<Carro>> fetch(String tipo) async {
    try {
      List<Carro> carros = await CarrosApi.getCarrosByTipo(tipo, _page);

      add(carros);

      return carros;
    } catch (e) {
      addError(e);
    }

    return [];
  }

  Future? fetchMore(String tipo) {
    _page++;
    fetch(tipo);
  }
}