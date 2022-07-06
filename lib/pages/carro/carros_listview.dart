import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carro_page.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carros_block.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class CarrosListView extends StatefulWidget {
  String tipo;
  CarrosListView(this.tipo);

  @override
  State<CarrosListView> createState() => _CarrosListViewState();
}

class _CarrosListViewState extends State<CarrosListView> with AutomaticKeepAliveClientMixin<CarrosListView>{
  List<Carro> carros;

  final _bloc = CarrosBlock();

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

    if(carros == null ) {
      return Center(child: CircularProgressIndicator(),
      );
    }

    return _listView(carros);
  }

  Container _listView(List<Carro> carros) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: carros != null ? carros.length : 0,
        itemBuilder: (context, index) {
          Carro c = carros[index];

          return Card(
            color: Colors.grey[100],
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.network(
                      c.urlFoto ??
                          "https://s3-sa-east-1.amazonaws.com/videos.livetouchdev.com.br/esportivos/Maserati_Grancabrio_Sport.png",
                      width: 150,
                    ),
                  ),
                  Text(
                    c.nome ?? 'Erro',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Descrição...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('Detalhes'),
                        onPressed: () => _onClickCarro(context, c),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Share'),
                        onPressed: () {
                          /* ... */
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _onClickCarro(context, Carro c) {
    push(context, CarroPage(c));
  }

  @override
  dispose() {
    super.dispose();

    _bloc.dispose();
  }
}
