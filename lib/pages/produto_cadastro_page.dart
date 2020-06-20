import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sticker_fun/controllers/produto_controller.dart';
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/pages/produto_page.dart';
import 'package:sticker_fun/widgets/app_images_field.dart';

class ProdutoCadastroPage extends StatefulWidget {
  final Produto produto;
  final Categoria categoria;

  ProdutoCadastroPage({@required this.categoria, this.produto});

  @override
  _ProdutoCadastroPageState createState() => _ProdutoCadastroPageState();
}

class _ProdutoCadastroPageState extends State<ProdutoCadastroPage> {
  TextEditingController _tituloControl;
  TextEditingController _detalhesControl;
  TextEditingController _valorController;

  final ProdutoController _produtoController = ProdutoController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tituloControl = TextEditingController();
    _detalhesControl = TextEditingController();
    _valorController = TextEditingController();
    _valorController.text = '0.00';
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
        title: Text(widget.categoria.descCategoria, overflow: TextOverflow.ellipsis,),
        actions: <Widget>[
          FlatButton(
            child: Text('SALVAR'),
            onPressed: () => _SalvarProduto(),
          )
        ],
      ),
      body: Body(),
    );
  }

  Body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppImagesField(
                  onSaved: (images) {
                    if ((images != null) && (images.length > 0)) {
//                    _produtoController.produto.imagens.clear();
                      List<Imagens> list = List<Imagens>();
                      for (var img in images) {
                        list.add(Imagens(
                            url: '',
                            codProduto: 0,
                            codProdutoImagem: 0,
                            descImagem: '',
                            imagem: base64Encode(img.readAsBytesSync())));
                      }
                      _produtoController.produto.imagens = list;
                    }
                  },
                  initialValue:
                      widget.produto != null ? widget.produto.imagens : [],
                ),
                Titulo(),
                Valor(),
                Detalhes(),
//                BotaoSalvar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Titulo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          controller: _tituloControl,
          maxLines: 1,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: 'Descrição',
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Título do produto",
            hintStyle: TextStyle(
              fontSize: 15.0,
//              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Detalhes() {
    return Container(
      height: 200.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: TextField(
          controller: _detalhesControl,
          minLines: null,
          maxLines: 2,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: 'Detalhes',
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Detalhes do produto",
            hintStyle: TextStyle(
              fontSize: 15.0,
//              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Valor() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: _valorController,
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefix: Text('R\$ '),
          labelText: 'Valor',
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: "Valor do produto",
          hintStyle: TextStyle(
            fontSize: 15.0,
//              color: Colors.black,
          ),
        ),
      ),
    );
  }

  BotaoSalvar() {
    return Positioned(
      bottom: 10.0,
      left: 8.0,
      right: 8.0,
      child: Container(
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
              if (_formKey.currentState.validate())
                _formKey.currentState.save();
              _SalvarProduto();
            },
          )),
    );
  }

  _SalvarProduto() {
    _produtoController.produto.descProduto = _tituloControl.text;
    _produtoController.produto.valor = double.parse(_valorController.text);
    _produtoController.produto.detalhes = _detalhesControl.text;
    _produtoController.produto.codCategoria = widget.categoria.codCategoria;

    Produto p = _produtoController.updateProduto(_produtoController.produto);

    if (p != null)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ProdutoPage(produto: p);
      }));
  }
}
