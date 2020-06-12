import 'package:flutter/material.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/widgets/app_produto_titulo.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoPage extends StatefulWidget {

  final Produto produto;


  ProdutoPage({this.produto});

  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.produto.descProduto),
        /*leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),*/
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Body(),
    );
  }

  Body(){
   return Stack(
      children: <Widget>[
        FadeInImage.memoryNetwork(
          height: MediaQuery.of(context).size.height * 0.33,
          width: MediaQuery.of(context).size.width,
          placeholder: kTransparentImage,
          fit: BoxFit.cover,
          image: widget.produto.imagens[0].url,
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.33-30.0),
          child: ItemInfo(),
        ),
      ],
    );
  }

  ItemInfo() {
    return Container(
      padding: EdgeInsets.all(20),
//      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          shopeName(name: "MacDonalds"),
          AppProdutoTitulo(
            name: widget.produto.descProduto,
            numOfReviews: 24,
            rating: 4,
            price: widget.produto.valor.round()
          ),
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
}
