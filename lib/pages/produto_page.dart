import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycatalog/controllers/produto_controller.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/pages/produto_cadastro_page.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoPage extends StatefulWidget {
  final Produto produto;
  final Categoria categoria;

  ProdutoPage({this.produto, this.categoria});

  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final ProdutoController produtoController = ProdutoController();

  final picker = ImagePicker();

  TextEditingController _tituloControl;
  TextEditingController _detalhesControl;
  TextEditingController _valorController;

  int _current = 0;

  List<Imagens> listImagens;

  @override
  void initState() {
    super.initState();
    _tituloControl = TextEditingController();
    _detalhesControl = TextEditingController();
    _valorController = TextEditingController();
    listImagens = List<Imagens>();

    if (widget.produto != null) {
      _tituloControl.text = widget.produto.descProduto;
      _valorController.text = widget.produto.valor.toStringAsFixed(2);
      _detalhesControl.text = widget.produto.detalhes;
      listImagens = widget.produto.imagens;
    }
  }

  @override
  void dispose() {
    _tituloControl.dispose();
    _detalhesControl.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        actions: <Widget>[
          _ButtomEdit(),
//          IconButton(icon: Icon(Icons.share)),
        ],
      ),
      body: Body(),
    );
  }

  Body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[_Carousel(), ImagemIndicator(), ItemInfo()],
      ),
    );
  }

  ItemInfo() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Observer(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _Titulo(),
                _Valor(),
                Divider(),
                _Detalhes(),
              ],
            );
          },
        ));
  }

  ImagemIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listImagens.map((url) {
        int index = listImagens.indexOf(url);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == index
                ? Theme.of(context).primaryColor //Color.fromRGBO(0, 0, 0, 0.9)
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        );
      }).toList(),
    );
  }

  ImagemBase64(String img64) {
    final decodedBytes = base64Decode(img64);
    return Image.memory(decodedBytes, fit: BoxFit.cover);
  }

  _Carousel() {
    return CarouselSlider(
      options: CarouselOptions(
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
          height: MediaQuery.of(context).size.height * 0.4),
      items: listImagens.map((i) {
        return Builder(
          builder: (BuildContext context) {
            if (i.imagem.isNotEmpty) return ImagemBase64(i.imagem);

            return FadeInImage.memoryNetwork(
              width: MediaQuery.of(context).size.width,
              placeholder: kTransparentImage,
              fit: BoxFit.cover,
              image: i.url,
            );
          },
        );
      }).toList(),
    );
  }

  _ButtomEdit() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ProdutoCadastroPage(
            produto: widget.produto,
            categoria: widget.categoria,
          );
        }));
      },
    );
  }

  _Titulo(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.produto.descProduto,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        ],
      ),
    );
  }

  _Detalhes() {
    return Text(
      widget.produto != null ? widget.produto.detalhes : '',
      style: TextStyle(
        height: 1.5,
      ),
    );
  }

  _Valor() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "R\$ ${widget.produto.valor.toStringAsFixed(2)}",
        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 22) ,
      ),
    );
  }
}
