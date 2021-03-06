import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/pages/produto_page.dart';
import 'package:transparent_image/transparent_image.dart';

class AppSlideItem extends StatefulWidget {
  final Produto produto;
  final Categoria categoria;

  AppSlideItem({@required this.produto, @required this.categoria});

  @override
  _AppSlideItemState createState() => _AppSlideItemState();
}

class _AppSlideItemState extends State<AppSlideItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ProdutoPage(
              produto: widget.produto, categoria: widget.categoria);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        height: 300, //MediaQuery.of(context).size.height / 2.9,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 190.0, // MediaQuery.of(context).size.height / 3.7,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: widget.produto.imagens.length > 0
                          ? ImagemUrl()
                          : Container(),
                    ),
                  ),
//                  _Rating(),
                  _Promocoes(),
                ],
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.only(left: 12.0, right: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.produto.descProduto}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.only(left: 12.0, right: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.produto.detalhes,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImagemUrl() {
    return widget.produto.imagens[0].imagem.isNotEmpty
        ? Image.memory(base64Decode(widget.produto.imagens[0].imagem))
        : FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            fit: BoxFit.cover,
            image: widget.produto.imagens[0].url,
          );
  }

  _Promocoes() {
    return widget.produto.percDesconto <= 0
        ? Container()
        : Positioned(
            top: 6.0,
            left: 6.0,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  widget.produto.percDesconto.toString() + ' %',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
  }

  _Rating() {
    return Positioned(
      top: 6.0,
      right: 6.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 10,
              ),
              Text(
                " 4.5 ",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
