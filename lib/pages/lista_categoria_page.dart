import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sticker_fun/controllers/gif_controller.dart';
import 'package:sticker_fun/controllers/menu_controller.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/gif.dart';
import 'package:sticker_fun/models/menu.dart';
import 'package:sticker_fun/utils/dialogs.dart';
import 'package:sticker_fun/widgets/app_grid_tile.dart';
import 'package:sticker_fun/widgets/app_grid_tile_add.dart';
import 'package:sticker_fun/widgets/app_gridview_error.dart';
import 'package:sticker_fun/widgets/app_slivertoboxadapter.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuController _menuController = MenuController();
  GifController gifController = GifController();
  Locale myLocale;

  TextEditingController _textController;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _menuController.getMenusSqlite();
    _textController = TextEditingController();

    scrollController.addListener(() {
      if ((scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) &&
          (gifController.status != Status.error))
        gifController.getSearch(_textController.text, myLocale.languageCode);
    });

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
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
                _onAddPressed(context);
              }),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          if (_menuController.status == Status.loading)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (_menuController.status == Status.error)
            return Center(
                child: AppGridViewError(
              iconSize: 28.0,
              onButtonClick: _menuController.getMenusSqlite,
            ));

          return _listMenu();
        },
      ),
    );
  }

  _listMenu() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _menuController.listMenu.length,
        itemBuilder: (BuildContext context, int index) {
          Menu menu = _menuController.listMenu[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              leading: SizedBox(
                  width: 50.0,
                  child: CachedNetworkImage(
                    imageUrl: menu.url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            LinearProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),

              /*FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage, image: menu.url),
                          ),*/
              title: Text(
                menu.title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    print('MENU ID>>>' + menu.id.toString());
                    //if (i > 0) _menuController.getMenusSqlite();
                    Dialogs.showQuestion(
                            context, 'Deletar menu', "Deseja deletar menu?")
                        .then((value) async {
                      if (value) {
                        int i = await _menuController.deleteMenuSqlite(menu.id);
                      }
                    });
                  }),
            ),
          );
        },
      ),
    );
  }

  void _onAddPressed(context) {
    showModalBottomSheet(
        context: context,
        builder: ((_) {
          return Column(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: tr('searchHere'),
                  ),
                  controller: _textController,
                  onSubmitted: (value) {
                    if (value.length > 2)
                      gifController.getSearch(value, myLocale.languageCode);
                  },
                ),
                trailing: Icon(
                  Icons.search,
                ),
                onTap: () {
                  if (_textController.text.length > 2)
                    gifController.getSearch(
                        _textController.text, myLocale.languageCode);
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                child: Observer(builder: (BuildContext context) {
                  if ((gifController.status == Status.loading) &&
                      (gifController.listGif.length == 0))
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  if ((gifController.status == Status.error) &&
                      (gifController.listGif.length == 0))
                    return Center(
                        child: AppGridViewError(
                      iconSize: 28.0,
                      onButtonClick: gifController.getTrending,
                    ));

                  return CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 2.0, crossAxisCount: 3),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            Gif gif = gifController.listGif[index];
                            return AppGridTileAdd(
                              gif: gif,
                              onAddClick: () async {
                                int i = await _addMenu(gif);
                                if (i > 0) {
                                  _menuController.getMenusSqlite();
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                          childCount: gifController.listGif.length,
                        ),
                      ),
                      AppSliverToBoxAdapter(
                        status: gifController.status,
                        onButtonClick: gifController.getTrending,
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        }));
  }

  Future<int> _addMenu(Gif gif) async {
    int i = await _menuController.addMenuSqlite(
        _textController.text.toUpperCase(), gif);
    return i;
  }
}
