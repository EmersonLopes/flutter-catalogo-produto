import 'package:flutter/material.dart';
import 'package:sticker_fun/models/produto.dart';

class ProdutoCadastroPage extends StatefulWidget {
  final Produto produto;

  ProdutoCadastroPage({this.produto});

  @override
  _ProdutoCadastroPageState createState() => _ProdutoCadastroPageState();
}

class _ProdutoCadastroPageState extends State<ProdutoCadastroPage> {
  TextEditingController _tituloControl;
  TextEditingController _detalhesControl;
  TextEditingController _valorController;

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
        title: Text('Produto'),
      ),
      body: Body(),
    );
  }

  Body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          IconeTirarFoto(),
          Titulo(),
          Valor(),
          Detalhes(),
          BotaoSalvar()
        ],
      ),
    );
  }

  Titulo() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
              color: Colors.white,
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
    );
  }

  Valor() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
              color: Colors.white,
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

  IconeTirarFoto() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Column(
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
      ),
    );
  }

  BotaoSalvar() {
    return Container(
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
            //_SalvarCategoria();
          },
        ));
  }
}
