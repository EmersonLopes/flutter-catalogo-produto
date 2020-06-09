import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:sticker_fun/controllers/gif_controller.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/gif.dart';
import 'package:sticker_fun/themes/theme_store.dart';
import 'package:sticker_fun/utils/constants.dart';
import 'package:sticker_fun/widgets/app_drawer.dart';
import 'package:sticker_fun/widgets/app_grid_tile.dart';
import 'package:sticker_fun/widgets/app_gridview_error.dart';
import 'package:sticker_fun/widgets/app_iconbutton_search.dart';
import 'package:sticker_fun/widgets/app_slivertoboxadapter.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  GifController gifController = GifController();
  ScrollController scrollController = ScrollController();
  ThemeStore themeStore;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 50.0) &&
          (gifController.status != Status.error)) gifController.getTrending();
    });

    gifController.getTrending();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    themeStore ??= Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SafeArea(
          child: AppDrawer(),
        ),
        appBar: AppBar(
          title: Text(Constants.APP_NAME),
          actions: <Widget>[
            AppIconButtonSearch(),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _onSettingsPressed(context);
              },
            )
          ],
        ),
        body: _body());
  }

  _body() {
    return Observer(
      builder: (BuildContext context) {
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
                  mainAxisSpacing: 2.0, crossAxisCount: 2),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Gif gif = gifController.listGif[index];
                  return AppGridTile(gif);
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
      },
    );
  }

  void _onSettingsPressed(context) {
    showModalBottomSheet(
        context: context,
        builder: ((_) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.brightness_2,
                  color: Colors.amber,
                ),
                title: Text('Dark Theme'),
                trailing: Switch(
                  value: themeStore.isDark,
                  onChanged: (value) => themeStore.toggleTheme(),
//            activeTrackColor: Colors.lightGreenAccent,
//            activeColor: Colors.green,
                ),
              )
            ],
          );
        }));
  }
}
