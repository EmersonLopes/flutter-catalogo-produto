import 'package:mobx/mobx.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/repositories/api/api_categorias.dart';

part 'categoria_controller.g.dart';

class CategoriaController = _CategoriaController with _$CategoriaController;

abstract class _CategoriaController with Store {
  final _apiGiphy = ApiCategorias();
  int _offset = 0;

  ObservableList<Categoria> listCategorias = ObservableList<Categoria>();

  @observable
  Status status = Status.none;

  @action
  getCategorias() async {
    try {
      status = Status.loading;
      List<Categoria> list = await _apiGiphy.getCategorias(_offset);
      listCategorias.addAll(list);
      status = Status.success;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }
}
