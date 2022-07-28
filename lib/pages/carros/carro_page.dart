import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_form_page.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/loripsum_api.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarroPage extends StatefulWidget {
  Carro carro;

  CarroPage(this.carro);

  @override
  State<CarroPage> createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumApiBloc = LoripsumBloc();

  Color color = Colors.grey;

  Carro get carro => widget.carro;

  @override
  void initState() {
    super.initState();

    FavoritoService().isFavorito(carro).then((bool favorito) {
      setState((){
        color = favorito ? Colors.red : Colors.grey;
      });
    });

    _loripsumApiBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.carro.nome,
        ),
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
            onSelected: _onClickPopupMenu,
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
          CachedNetworkImage(
            imageUrl: widget.carro.urlFoto ?? "https://s3-sa-east-1.amazonaws.com/videos.livetouchdev.com.br/esportivos/Maserati_Grancabrio_Sport.png",
          ),
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
            Container(
              width: 280,
              child: text(
                widget.carro.nome,
                fontSize: 20,
                bold: true,
              ),
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
                color: color,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: _onClickShare,
              icon: Icon(
                Icons.share,
                size: 35,
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
        SizedBox(
          height: 20,
        ),
        text(
          widget.carro.descricao ?? '',
          fontSize: 16,
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<String>(
          stream: _loripsumApiBloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                padding: EdgeInsets.all(45),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return text(snapshot.data, fontSize: 16);
          },
        ),
      ],
    );
  }

  void _onClickMapa() {}

  void _onClickVideo() {
    if(carro.urlVideo != null && carro.urlVideo.isNotEmpty){
      launchUrl(Uri.parse(carro.urlVideo));
    } else {
      alert(context, '[ERRO] Este carro não possui vídeo.');
    }
  }

  _onClickPopupMenu(String value) {
    switch (value) {
      case 'Editar':
        print('Editar ');
        push(context, CarroFormPage(carro: carro,));
        break;
      case 'Deletar':
        print('Deletar');
        deletar();
        break;
      case 'Share':
        print('Share');
        break;
    }
  }

  void _onClickFavorito() async {
    bool? favorito = await FavoritoService().favoritar(carro);

    setState((){
      color = favorito! ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  void deletar() async {
    ApiResponse<bool> response = await CarrosApi.delete(carro);

    if(response.ok == true) {
      alert(context, "Carro deletado com sucesso!", callback: (){Navigator.pop(context);},);
    } else {
      alert(context, response.msg);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _loripsumApiBloc.dispose();
  }
}
