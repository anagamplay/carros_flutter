import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CarrosListView extends StatelessWidget {
  List<Carro>? carros;

  CarrosListView(this.carros);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: carros?.length,
        itemBuilder: (context, index) {
          Carro c = carros![index];

          return InkWell(
            onTap: () {
              _onClickCarro(context, c);
            },
            onLongPress: () {
              _onLongClickCarro(context, c);
            },
            child: Card (
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: c.urlFoto ?? "https://s3-sa-east-1.amazonaws.com/videos.livetouchdev.com.br/esportivos/Maserati_Grancabrio_Sport.png",
                        width: 250,
                        height: 120,
                      ),
                    ),
                    Text(
                      c.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      c.descricao ?? '',
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
                            _onClickShare(context, c);
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onClickCarro(context, Carro c) {
    push(context, CarroPage(c));
  }

  void _onLongClickCarro(BuildContext context, Carro c) {
    showModalBottomSheet(context: context, builder: (context){
    // Ou showDialog() {}
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              c.nome,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          ListTile(
            title: Text('Detalhes'),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.pop(context);
              _onClickCarro(context, c);
            },
          ),
          ListTile(
            title: Text('Share'),
            leading: Icon(Icons.share,),
            onTap: () {
              Navigator.pop(context);
              _onClickShare(context, c);
            },
          )
        ],
      );
    });
  }

  void _onClickShare(BuildContext context, Carro c) {
    print('Share ${c.nome}');

    Share.share(c.urlFoto ?? "https://s3-sa-east-1.amazonaws.com/videos.livetouchdev.com.br/esportivos/Maserati_Grancabrio_Sport.png");
  }
}
