import 'dart:convert';
import 'dart:typed_data';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycatalog/controllers/produto_controller.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/pages/produto_page.dart';
import 'package:mycatalog/widgets/app_images_field.dart';

class ProdutoCadastroPage extends StatefulWidget {
  final Produto produto;
  final Categoria categoria;

  ProdutoCadastroPage({@required this.categoria, @required this.produto});

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

    if (widget.produto == null) {
      _tituloControl.text = '';
      _valorController.text = '0.00';
      _detalhesControl.text = '';
    } else {
      _tituloControl.text = widget.produto.descProduto;
      _valorController.text = widget.produto.valor.toStringAsFixed(2);
      _detalhesControl.text = widget.produto.detalhes;
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
        title: Text(
          widget.categoria.descCategoria?? widget.produto.descProduto,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('SALVAR'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                await _SalvarProduto();
              }
            },
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
                  initialValue: widget.produto != null
                      ? ImagensToUint8List(widget.produto.imagens)
                      : [],
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
        child: TextFormField(
          controller: _tituloControl,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) return 'Informe uma descrição';

            return null;
          },
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
        child: TextFormField(
          controller: _detalhesControl,
          minLines: null,
          maxLines: 2,
          validator: (value) {
            if (value.isEmpty) return 'Informe os detalhes';

            return null;
          },
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
      child: TextFormField(
        controller: _valorController,
        validator: (value) {
          if ((value.trim().isEmpty) || (double.tryParse(value.replaceAll('.','').replaceAll(',', '.')) == null))
            return 'Valor inválido';

          return null;
        },
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
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          RealInputFormatter(centavos: true)
        ],
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
            onPressed: () async {
              if (_formKey.currentState.validate())
                _formKey.currentState.save();
              await _SalvarProduto();
            },
          )),
    );
  }

  _SalvarProduto() async {
    _produtoController.produto.descProduto = _tituloControl.text;
    _produtoController.produto.valor = double.tryParse(_valorController.text.replaceAll('.','').replaceAll(',', '.'));
    _produtoController.produto.detalhes = _detalhesControl.text;
    _produtoController.produto.codCategoria = widget.categoria.codCategoria;

    Produto p =
        await _produtoController.updateProduto(_produtoController.produto);

    if (p != null)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ProdutoPage(produto: p);
      }));
  }

  ImagensToUint8List(List<Imagens> imagens) {
    List<Uint8List> files = List<Uint8List>();

    for (var img in imagens) {
      var uint8 = base64Decode(img.imagem);
      files.add(uint8);
    }

    return files;
  }
}
