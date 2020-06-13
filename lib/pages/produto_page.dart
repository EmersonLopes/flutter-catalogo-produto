import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/pages/produto_cadastro_page.dart';
import 'package:sticker_fun/widgets/app_produto_titulo.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoPage extends StatefulWidget {
  final Produto produto;

  ProdutoPage({this.produto});

  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return ProdutoCadastroPage();
            }));
          },),
          IconButton(icon: Icon(Icons.share)),
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
          CarouselSlider(
            options: CarouselOptions(
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                height: MediaQuery.of(context).size.height * 0.4),
            items: widget.produto.imagens.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return FadeInImage.memoryNetwork(
                    width: MediaQuery.of(context).size.width,
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                    image: i.url,
                  );
                },
              );
            }).toList(),
          ),
          ImagemIndicator(),
          ItemInfo(),
        ],
      ),
    );
  }

  ItemInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          //shopeName(name: "MacDonalds"),
          AppProdutoTitulo(
              name: widget.produto.descProduto,
              numOfReviews: 24,
              rating: 4,
              price: widget.produto.valor.round()),
          Text(
            widget.produto.detalhes,
            style: TextStyle(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Row shopeName({String name}) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        SizedBox(width: 10),
        Text(name),
      ],
    );
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
      children: widget.produto.imagens.map((url) {
        int index = widget.produto.imagens.indexOf(url);
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
}
