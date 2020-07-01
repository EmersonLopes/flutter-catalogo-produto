import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mycatalog/controllers/produto_controller.dart';
import 'package:mycatalog/controllers/status_ext.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/widgets/app_list_tile.dart';
import 'package:mycatalog/widgets/app_search.dart';

class PesquisaPage extends StatefulWidget {
  final String descricao;

  const PesquisaPage({@required this.descricao});

  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  ProdutoController produtoController = ProdutoController();

  @override
  void initState() {
    super.initState();
    produtoController.getProdutosDescricao(widget.descricao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _body());
  }

  _body() {
    return Observer(
      builder: (BuildContext context) {
        if ((produtoController.status == Status.loading) &&
            (produtoController.listProdutos.length == 0))
          return Center(
            child: CircularProgressIndicator(),
          );

        if ((produtoController.status == Status.error) &&
            (produtoController.listProdutos.length == 0))
          return Container(
            child: Text('Não possível carregar informações'),
          );

        if (produtoController.listProdutos.length == 0)
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.announcement,
                  size: 30.0,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                SizedBox(height: 4.0),
                Text('Nenhum produto encontrado para essa descrição.'),
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
                  child: AppListTile(
                    produto: produto,
                    categoria: Categoria(codCategoria: produto.codCategoria),
                  ));
            },
          ),
        );
      },
    );
  }

  _AppBar() {
    return PreferredSize(
      child: AppSearch(onSubmitted: (value) {
        produtoController.getProdutosDescricao(value);
      }, prefixIcon: IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () {
        Navigator.pop(context);
      },
      ),),
      preferredSize: Size(
        MediaQuery
            .of(context)
            .size
            .width,
        60.0,
      ),
    );
  }

}
