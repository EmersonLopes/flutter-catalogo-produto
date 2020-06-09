import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sticker_fun/controllers/produto_controller.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/widgets/app_list_tile.dart';
import 'package:sticker_fun/widgets/app_slide_item.dart';

class ListaProdutosPage extends StatefulWidget {

  final String titulo;


  ListaProdutosPage({this.titulo = "Produtos"});

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  ProdutoController produtoController = ProdutoController();


  @override
  void initState() {
    super.initState();
    produtoController.getMaisVendidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.titulo),
        ),
        body: _body());
  }

  _body() {
    return Observer(
      builder: (BuildContext context) {
        if ((produtoController.status == Status.loading) &&
            (produtoController.listMaisVendidos.length == 0))
          return
              Center(child: CircularProgressIndicator(),);

        if ((produtoController.status == Status.error) &&
            (produtoController.listMaisVendidos.length == 0))
          return Container(
            child: Text('Não possível carregar informações'),
          );

        return Container(
//          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: produtoController.listMaisVendidos == null
                ? 0
                : produtoController.listMaisVendidos.length,
            itemBuilder: (BuildContext context, int index) {
              Produto produto = produtoController.listMaisVendidos[index];

              return Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: AppListTile(produto: produto,),

                /*AppSlideItem(
                  img: produto.imagens[0].url,
                  title: produto.descProduto,
                  detalhes: produto.detalhes,
                  rating: "4.5",
                ),*/
              );
            },
          ),
        );
      },
    );
  }
}
