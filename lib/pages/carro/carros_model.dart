import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:mobx/mobx.dart';

part 'carros_model.g.dart';

class CarrosModel = CarrosModelBase with _$CarrosModel;

abstract class ModelBase with Store {
  @observable
  List<Carro>? carros;

  @observable
  Exception? error;

  @action
  fetch(String tipo) async{
    try {

      carros = await CarrosApi.getCarros(tipo);

    } catch(e) {
      error = e as Exception?;
    }
  }
}