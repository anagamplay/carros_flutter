import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';

class FavoritosBloc extends SimpleBloc<List<Carro>> {

  fetch() async{
    try {

      List<Carro>? carros = await FavoritoService.getCarros();

      if(carros!.isNotEmpty) {
        final dao = CarroDAO();

        //Salvar todos os carros
        carros.forEach(dao.save);
      }

      add(carros);

      return carros;
    } catch(e) {
      addError(e);
    }
  }
}