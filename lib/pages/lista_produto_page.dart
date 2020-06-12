import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sticker_fun/controllers/produto_controller.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/pages/produto_page.dart';
import 'package:sticker_fun/widgets/app_list_tile.dart';
import 'package:sticker_fun/widgets/app_slide_item.dart';

class ListaProdutosPage extends StatefulWidget {

  final Categoria categoria;


  ListaProdutosPage(this.categoria);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  ProdutoController produtoController = ProdutoController();


  @override
  void initState() {
    super.initState();
    produtoController.getProdutos(widget.categoria.codCategoria.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoria.descCategoria),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ProdutoPage();
                      }));
                }),
          ],
        ),
        body: _body());
  }

  _body() {
    return Observer(
      builder: (BuildContext context) {
        if ((produtoController.status == Status.loading) &&
            (produtoController.listProdutos.length == 0))
          return
              Center(child: CircularProgressIndicator(),);

        if ((produtoController.status == Status.error) &&
            (produtoController.listProdutos.length == 0))
          return Container(
            child: Text('Não possível carregar informações'),
          );

        print(produtoController.listProdutos?.length.toString());
        if (produtoController.listProdutos?.length == 0)
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.announcement, size: 30.0, color: Theme.of(context).primaryColor,),
                SizedBox(height: 4.0),
                Text('Nenhum produto encontrado para essa categoria.'),
              ],
            ),
          );

        return Container(
//          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: produtoController.listProdutos == null
                ? 0
                : produtoController.listProdutos.length,
            itemBuilder: (BuildContext context, int index) {
              Produto produto = produtoController.listProdutos[index];

              return Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: AppListTile(produto: produto)
              );
            },
          ),
        );
      },
    );
  }
}
