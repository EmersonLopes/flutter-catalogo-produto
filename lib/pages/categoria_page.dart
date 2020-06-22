import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycatalog/controllers/categoria_controller.dart';
import 'package:mycatalog/widgets/app_image_source_sheet.dart';
import '../models/categoria.dart';


class CategoriaPage extends StatefulWidget {
  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  final CategoriaController _categoriaController = CategoriaController();
  TextEditingController _textDescricaoController;
  final picker = ImagePicker();

  @override
  void initState() {
    _textDescricaoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textDescricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria'),
        actions: <Widget>[
          FlatButton(
            child: Text('LIMPAR'),
            onPressed: () {
              _categoriaController.setImage(null);
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextField(
            controller: _textDescricaoController,
            decoration:
                InputDecoration(hintText: 'Informe a descrição da categoria'),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Observer(builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    _onAddPressed();
                  },
                  child: _categoriaController.image == null
                      ? _IconeTirarFoto()
                      : Image.file(
                          _categoriaController.image,
                          fit: BoxFit.cover,
                        ),
                );
              }),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.white, //Theme.of(context).primaryColor,
                child: Text(
                  'Salvar',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Theme.of(context).accentColor)),
                onPressed: () {
                  _SalvarCategoria();
                },
              ))
        ],
      ),
    );
  }

  void _onAddPressed() {
    showModalBottomSheet(
        context: context,
        builder: ((_) {
          return AppimageSourceSheet(
              (file) => _categoriaController.setImage(file));
        }));
  }

  _IconeTirarFoto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(Icons.photo_camera,
            size: 50.0, color: Theme.of(context).primaryColor),
        Text(
          'Incluir imagem',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor),
        )
      ],
    );
  }

  Future<void> _SalvarCategoria() async {
    Categoria categoria = Categoria();
    categoria.codCategoria = 0;
    categoria.descCategoria = _textDescricaoController.text;
    var bytes = _categoriaController.image.readAsBytesSync();
    categoria.imagem = base64Encode(bytes);
    Categoria c = await _categoriaController.updateCategoria(categoria);
    if (c.codCategoria > 0) Navigator.pop(context, true);
  }
}
