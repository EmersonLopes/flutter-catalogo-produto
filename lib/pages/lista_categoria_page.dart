import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sticker_fun/controllers/categoria_controller.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/pages/categoria_page.dart';
import 'package:sticker_fun/utils/dialogs.dart';
import 'package:transparent_image/transparent_image.dart';

class ListaCategoriaPage extends StatefulWidget {
  @override
  _ListaCategoriaPageState createState() => _ListaCategoriaPageState();
}

class _ListaCategoriaPageState extends State<ListaCategoriaPage> {
  final CategoriaController _categoriaController = CategoriaController();

  Locale myLocale;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _categoriaController.getCategorias();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    myLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return CategoriaPage();
                }));
              }),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          if (_categoriaController.status == Status.loading)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (_categoriaController.status == Status.error)
            return Center(
                child: Text('Não foi possível carregar as informações'));

          return _listCategorias();
        },
      ),
    );
  }

  _listCategorias() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _categoriaController.listCategorias.length,
        itemBuilder: (BuildContext context, int index) {
          Categoria categoria = _categoriaController.listCategorias[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: categoria.url),
              ),
              title: Text(
                categoria.descCategoria,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    print('MENU ID>>>' + categoria.codCategoria.toString());
                    //if (i > 0) _menuController.getMenusSqlite();
                    Dialogs.showQuestion(
                            context, 'Deletar menu', "Deseja deletar menu?")
                        .then((value) async {
                      /*if (value) {
                        int i = await _categoriaController.deleteMenuSqlite(menu.id);
                      }*/
                    });
                  }),
            ),
          );
        },
      ),
    );
  }



}