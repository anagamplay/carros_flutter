import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/loripsum_api.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';

class CarroPage extends StatefulWidget {

  Carro carro;

  CarroPage(this.carro);

  @override
  State<CarroPage> createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumApiBloc = LoripsumBloc();

  @override
  void initState() {
    super.initState();

    _loripsumApiBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            onPressed: _onClickMapa,
            icon: Icon(Icons.place),
          ),
          IconButton(
            onPressed: _onClickVideo,
            icon: Icon(Icons.videocam),
          ),
          PopupMenuButton<String>(
            onSelected: _onCLockPopupMenu,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Editar',
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: 'Deletar',
                  child: Text('Deletar'),
                ),
                PopupMenuItem(
                  value: 'Share',
                  child: Text('Share'),
                ),
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          Image.network(widget.carro.urlFoto),
          _bloco1(),
          Divider(),
          _bloco2(),
        ],
      ),
    );
  }

  Row _bloco1() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                text(
                  widget.carro.nome,
                  fontSize: 20,
                  bold: true,
                ),
                text(
                  widget.carro.tipo,
                  fontSize: 16,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: _onClickFavorito,
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                IconButton(
                  onPressed: _onClickShare,
                  icon: Icon(
                    Icons.share,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        );
  }

  _bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20,),
        text(widget.carro.descricao, fontSize: 16,),
        SizedBox(height: 20,),
        StreamBuilder<String>(
          stream: _loripsumApiBloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            }
            return text(snapshot.data, fontSize: 16);
          },
        ),
      ],
    );
  }

  void _onClickMapa() {}

  void _onClickVideo() {}

  _onCLockPopupMenu(String value) {
    switch (value) {
      case 'Editar':
        print('Editar ');
        break;
      case 'Deletar':
        print('Deletar');
        break;
      case 'Share':
        print('Share');
        break;
    }
  }

  void _onClickFavorito() {}

  void _onClickShare() {}

  @override
  void dispose() {
    super.dispose();

    _loripsumApiBloc.dispose();
  }
}