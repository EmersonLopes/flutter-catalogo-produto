import 'package:mobx/mobx.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/gif.dart';
import 'package:sticker_fun/models/giphy.dart';
import 'package:sticker_fun/repositories/api/api_giphy.dart';
import 'package:sticker_fun/repositories/sqlite/database_helper.dart';
import 'package:sticker_fun/utils/constants.dart';

part 'gif_controller.g.dart';

class GifController = _GifController with _$GifController;

abstract class _GifController with Store {
  final dbHelper = DatabaseHelper.instance;
  final _apiGiphy = ApiGiphy();
  int _offset = 0;

  ObservableList<Gif> listGif = ObservableList<Gif>();
  ObservableList<Gif> listGifLikes = ObservableList<Gif>();

  @observable
  Giphy giphy;

  @observable
  Status status = Status.none;

  @observable
  bool isLiked = false;

  @action
  getTrending() async {
    try {
      status = Status.loading;
      giphy = await _apiGiphy.getTrending(_offset);

      if (giphy.gifs.length > 0) {
        listGif.addAll(giphy.gifs);
      }
      _offset = giphy.pagination != null
          ? giphy.pagination.offset + giphy.pagination.count
          : _offset + giphy.pagination.count;

      if (giphy != null)
        status = Status.success;
      else
        status = Status.none;
      giphy = null;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  @action
  getSearch(String search, String lang) async {
    try {
      status = Status.loading;
      giphy = await _apiGiphy.getSearch(
        _offset,
        search,
        lang: lang,
      );

      if (giphy.gifs.length > 0) {
        listGif.addAll(giphy.gifs);
      }

      _offset = giphy.pagination != null
          ? giphy.pagination.offset + giphy.pagination.count
          : _offset + giphy.pagination.count;

      if (giphy != null)
        status = Status.success;
      else
        status = Status.none;
      giphy = null;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  @action
  getLikes() async {
    try {
      status = Status.loading;
      int id = 0;
      if (listGifLikes.length > 0) id = int.parse(listGifLikes.last.id);
      List<Map<String, dynamic>> list =
          //await dbHelper.queryAllRows(DatabaseHelper.tbGifsLike);
          await dbHelper.queryRowsOffset(DatabaseHelper.tbGifsLike, id,
              limit: Constants.LIST_LIKES_LENGHT);
      for (var l in list) {
        listGifLikes.add(Gif(
            id: l[DatabaseHelper.colGifsLikeCodigo].toString(),
            title: l[DatabaseHelper.colGifsLikeTitle],
            url: l[DatabaseHelper.colGifsLikeUrl],
            images: Images(
              fixedHeight:
                  FixedHeightSmall(url: l[DatabaseHelper.colGifsLikeUrl]),
              fixedHeightSmall:
                  FixedHeightSmall(url: l[DatabaseHelper.colGifsLikeUrl]),
            )));
      }
      status = Status.success;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  @action
  getIsLiked(String codigo) async {
    try {
      print('CODIGO>>>> $codigo');
      status = Status.loading;
      String s =
          await dbHelper.queryRowByCodigo(DatabaseHelper.tbGifsLike, codigo);
      print('QUERY>>>> $s');
      isLiked = s.length > 0;

      status = Status.success;
      return isLiked;
    } on Exception catch (e) {
      status = Status.error;
      isLiked = false;
    }
  }

  @action
  Future<void> onLiked(Gif gif) async {
    Map<String, dynamic> row = DatabaseHelper.getRowGifsLike(
        codigo: gif.id,
        title: gif.title,
        url: gif.images.fixedHeight.url,
        height: gif.images.fixedHeight.height,
        userDisplayName: gif.user?.displayName,
        userName: gif.user?.username,
        userAvatarUrl: gif.user?.avatarUrl,
        userBannerUrl: gif.user?.bannerUrl);
    final id = await dbHelper.insert(row, DatabaseHelper.tbGifsLike);
    isLiked = id > 0;
    print('inserted row id: $id');
  }

  @action
  onDisLiked(Gif gif) async {
    int i = await dbHelper.deleteByCodigo(DatabaseHelper.tbGifsLike, gif.id);
    isLiked = i > 0;
    if (i > 0)
      listGifLikes.removeWhere((g) {
        return g.id == gif.id;
      });
  }
}
