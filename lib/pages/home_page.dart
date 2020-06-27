import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:mycatalog/controllers/categoria_controller.dart';
import 'package:mycatalog/controllers/produto_controller.dart';
import 'package:mycatalog/controllers/status_ext.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/widgets/app_slide_item.dart';
import 'package:transparent_image/transparent_image.dart';

import 'lista_categoria_page.dart';
import 'lista_produto_page.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  ProdutoController produtoController = ProdutoController();
  CategoriaController categoriaController = CategoriaController();

  final TextEditingController _searchControl = new TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    CarregaInformacoes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

//    themeStore ??= Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _body());
  }

  _AppBar() {
    return PreferredSize(
      child: Padding(
        padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: Card(
          elevation: 6.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Procurar..",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
              controller: _searchControl,
            ),
          ),
        ),
      ),
      preferredSize: Size(
        MediaQuery
            .of(context)
            .size
            .width,
        60.0,
      ),
    );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: RefreshIndicator(
        onRefresh: () {
          return CarregaInformacoes();
        },
        child: ListView(
          children: <Widget>[
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Categorias",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "EDITAR",
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .accentColor,
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Icon(
                        Icons.edit,
                        size: 14.0,
                        color: Theme
                            .of(context)
                            .accentColor,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ListaCategoriaPage();
                        },
                      ),
                    ).then((onValue) {
                      categoriaController.getCategorias();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 6.0),
            _Categorias(),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Mais Vendidos",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.0),
            _ListaHorizontal(produtoController.listMaisVendidos),
            SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Promoções",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.0),
            _ListaHorizontal(produtoController.listPromocoes),
          ],
        ),
      ),
    );
  }

  _Categorias() {
    return Observer(
      builder: (BuildContext context) {
        if ((categoriaController.status == Status.loading) &&
            (categoriaController.listCategorias.length == 0))
          return SizedBox(
            height: 100.0,
            child: CardSkeleton(
              style: SkeletonStyle(
                isCircleAvatar: false,
                isShowAvatar: true,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                barCount: 0,
              ),
            ),
          );

        if ((categoriaController.status == Status.error) &&
            (categoriaController.listCategorias.length == 0))
          return Erro('Não possível carregar informações');

        return Container(
          height: 100.0, //MediaQuery.of(context).size.height / 6,
          child: ListView.builder(
            primary: false,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: categoriaController.listCategorias == null
                ? 0
                : categoriaController.listCategorias.length,
            itemBuilder: (BuildContext context, int index) {
              Categoria categoria = categoriaController.listCategorias[index];

              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ListaProdutosPage(categoria);
                      }));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: <Widget>[
                        categoria.imagem.isEmpty
                            ? FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          fit: BoxFit.cover,
                          image: categoria.url,
                          height: 100.0,
                          //MediaQuery.of(context).size.height / 6,
                          width:
                          100.0, //MediaQuery.of(context).size.height / 6,
                        )
                            : _ImagemBase64(categoria.imagem),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              stops: [0.2, 0.7],
                              colors: [
                                Color.fromARGB(100, 0, 0, 0),
                                Color.fromARGB(100, 0, 0, 0),
                              ],
                              // stops: [0.0, 0.1],
                            ),
                          ),
                          height: 100.0,
                          //MediaQuery.of(context).size.height / 6,
                          width:
                          100.0, //MediaQuery.of(context).size.height / 6,
                        ),
                        Center(
                          child: Container(
                            height: 100.0,
                            //MediaQuery.of(context).size.height / 6,
                            width: 100.0,
                            //MediaQuery.of(context).size.height / 6,
                            padding: EdgeInsets.all(1),
                            constraints: BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                categoria.descCategoria,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _ListaHorizontal(List list) {
    return Observer(
      builder: (BuildContext context) {
        if ((produtoController.status == Status.loading) &&
            (list.length == 0))
          return Container(
            height: 270.0, //MediaQuery.of(context).size.height / 2.4,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: CardSkeleton(
              style: SkeletonStyle(
                isCircleAvatar: false,
                isShowAvatar: true,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                barCount: 2,
              ),
            ),
          );

        if ((produtoController.status == Status.error) &&
            (list.length == 0))
          return Erro('Não possível carregar informações');
        //Horizontal List here
        return Container(
          height: 270.0, //MediaQuery.of(context).size.height / 2.4,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: list == null
                ? 0
                : list.length,
            itemBuilder: (BuildContext context, int index) {
              Produto produto = list[index];

              return Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: AppSlideItem(
                  produto: produto,
                  categoria: Categoria(codCategoria: produto.codCategoria),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> CarregaInformacoes() async {
    await categoriaController.getCategorias();
    await produtoController.getMaisVendidos();
    await produtoController.getPromocoes();
  }

  _ImagemBase64(String img64) {
    final decodedBytes = base64Decode(img64);
//    var file = File();
//    file.writeAsBytesSync(decodedBytes);
//    return Image.file(file, fit: BoxFit.cover);
    return Image.memory(
      decodedBytes,
      fit: BoxFit.cover,
      height: 100.0,
      width: 100.0,
    );
    /*
    _bytesImage = Base64Decoder().convert(_imgString);
    Image.memory(_bytesImage)
    Image.memory(_bytesImage).image*/
  }

  Erro(String msg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          Icons.error_outline,
          size: 28,
          color: Theme
              .of(context)
              .primaryColor

        ),
        Container(
          alignment: Alignment.center,
          child: Text(msg),
        ),
      ],
    );
  }

}
