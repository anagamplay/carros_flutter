import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:carros/utils/network.dart';

class CarrosBloc extends SimpleBloc<List<Carro>> {

  fetch(String tipo) async{
    try {

      if(!await isNetworkOn()) {
        List<Carro>? carros = await CarroDAO().findAllByTipo(tipo);
        add(carros!);
        return carros;
      }

      List<Carro> carros = await CarrosApi.getCarros(tipo);

      add(carros);

      return carros;
    } catch(e) {
      print(e);
      addError(e);
    }
  }
}