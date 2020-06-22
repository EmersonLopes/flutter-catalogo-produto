import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycatalog/controllers/produto_controller.dart';
import 'package:mycatalog/controllers/status_ext.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/pages/produto_cadastro_page.dart';
import 'package:mycatalog/widgets/app_produto_titulo.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoPage extends StatefulWidget {
  final Produto produto;
  final Categoria categoria;

  ProdutoPage({this.produto, this.categoria});

  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final ProdutoController produtoController = ProdutoController();

  final picker = ImagePicker();

  TextEditingController _tituloControl;
  TextEditingController _detalhesControl;
  TextEditingController _valorController;

  int _current = 0;

  List<Imagens> listImagens;

  @override
  void initState() {
    super.initState();
    _tituloControl = TextEditingController();
    _detalhesControl = TextEditingController();
    _valorController = TextEditingController();
    listImagens = List<Imagens>();

    if (widget.produto != null) {
      _tituloControl.text = widget.produto.descProduto;
      _valorController.text = widget.produto.valor.toStringAsFixed(2);
      _detalhesControl.text = widget.produto.detalhes;
      listImagens = widget.produto.imagens;
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
        title: Text('Detalhes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ProdutoCadastroPage(produto: widget.produto, categoria: widget.categoria,);
              }));
            },
          ),
//          IconButton(icon: Icon(Icons.share)),
        ],
      ),
      body: Body(),
    );
  }

  Body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Observer(builder: (BuildContext context) {
            return CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  height: MediaQuery.of(context).size.height * 0.4),
              items: listImagens.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    if (i.imagem.isNotEmpty) return ImagemBase64(i.imagem);

                    return FadeInImage.memoryNetwork(
                      width: MediaQuery.of(context).size.width,
                      placeholder: kTransparentImage,
                      fit: BoxFit.cover,
                      image: i.url,
                    );
                  },
                );
              }).toList(),
            );
          }),
          ImagemIndicator(),
          ItemInfo()
        ],
      ),
    );
  }

  ItemInfo() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Observer(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                produtoController.statusCad == StatusCad.none
                    ? AppProdutoTitulo(
                        name: widget.produto != null
                            ? widget.produto.descProduto
                            : '',
                        numOfReviews: 24,
                        rating: 4,
                        price: widget.produto != null
                            ? widget.produto.valor.round()
                            : 0)
                    : TituloCad(),
                produtoController.statusCad == StatusCad.none
                    ? Container()
                    : ValorCad(),
                produtoController.statusCad == StatusCad.none
                    ? Text(
                        widget.produto != null ? widget.produto.detalhes : '',
                        style: TextStyle(
                          height: 1.5,
                        ),
                      )
                    : DetalhesCad(),
              ],
            );
          },
        ));
  }

  OrderButton({size, Function() press}) {
    return Container(
      // padding: EdgeInsets.all(20),
      width: size.width * 0.8,
      // it will cover 80% of total width
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.shopping_cart),
                SizedBox(width: 10),
                Text(
                  "Order Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImagemIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listImagens.map((url) {
        int index = listImagens.indexOf(url);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == index
                ? Theme.of(context).primaryColor //Color.fromRGBO(0, 0, 0, 0.9)
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        );
      }).toList(),
    );
  }

  ImagemBase64(String img64) {
    final decodedBytes = base64Decode(img64);
    return Image.memory(decodedBytes, fit: BoxFit.cover);
  }

  TituloCad() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: TextField(
          controller: _tituloControl,
          maxLines: 2,
          style: Theme.of(context).textTheme.headline,
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

  DetalhesCad() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: _detalhesControl,
        minLines: null,
        maxLines: 4,
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

  ValorCad() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
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
    return InkWell(
      onTap: () {
        _onAddPressed();
      },
      child: Container(
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
      ),
    );
  }

  void _onAddPressed() {
    showModalBottomSheet(
        context: context,
        builder: ((_) {
          return SizedBox(
            height: 150.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
//                    color: Theme.of(context).accentColor,
                  ),
                  title: Text('Tirar foto'),
                  onTap: () {
                    _PegaImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.image,
//                    color: Theme.of(context).accentColor,
                  ),
                  title: Text('Escolher existente...'),
                  onTap: () async {
                    await _PegaImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }));
  }

  _PegaImage(ImageSource imageSource) async {
    var pickedFile = await picker.getImage(source: imageSource);
    /*if (pickedFile != null)
      _categoriaController.setImage(File(pickedFile.path));
    else
      _categoriaController.setImage(null);*/
  }
}
