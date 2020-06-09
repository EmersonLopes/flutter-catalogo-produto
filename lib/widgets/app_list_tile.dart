import 'package:flutter/material.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:transparent_image/transparent_image.dart';

class AppListTile extends StatefulWidget {
  final Produto produto;

  AppListTile({@required this.produto});

  @override
  _AppListTileState createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//      height: MediaQuery.of(context).size.height / 2.9,
//      width: MediaQuery.of(context).size.width / 1.2,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 3.0,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 200.0, //MediaQuery.of(context).size.height / 3.7,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      fit: BoxFit.cover,
                      image: widget.produto.imagens[0].url,
                    ),
                  ),
                ),
                _Rating(),
                _Promocao(),
              ],
            ),
            SizedBox(height: 7.0),
            _Title(),
            SizedBox(height: 7.0),
            _Preco(),
            SizedBox(height: 2.0),
            _Detalhes(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  _Title() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 4.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "${widget.produto.descProduto}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  _Preco() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 4.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "R\$ ${widget.produto.valor}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
//            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  _Detalhes() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "${widget.produto.detalhes}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  _Promocao() {
    return Positioned(
      top: 6.0,
      left: 6.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            " OURO 18K ",
            style: TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _Rating() {
    return Positioned(
      top: 6.0,
      right: 6.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.yellow[600],
                size: 10,
              ),
              Text(
                " 4.5 ",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
