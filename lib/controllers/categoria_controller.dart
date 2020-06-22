import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:mycatalog/controllers/status_ext.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/repositories/api/api_categorias.dart';

import '../models/categoria.dart';

part 'categoria_controller.g.dart';

class CategoriaController = _CategoriaController with _$CategoriaController;

abstract class _CategoriaController with Store {
  final _apiCategoria = ApiCategorias();
  int _offset = 0;

  ObservableList<Categoria> listCategorias = ObservableList<Categoria>();

  @observable
  File image = null;

  @observable
  Status status = Status.none;

  @action
  getCategorias() async {
    try {
      listCategorias.clear();
      status = Status.loading;
      List<Categoria> list = await _apiCategoria.getCategorias(_offset);
      listCategorias.addAll(list);
      status = Status.success;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  Future<Categoria> updateCategoria(Categoria categoria) async {
    try {
      status = Status.loading;
      Categoria c = await _apiCategoria.updateCategoria(categoria);
      status = Status.success;
      return c;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  @action
  setImage(File img){
    image = img;
  }
}
