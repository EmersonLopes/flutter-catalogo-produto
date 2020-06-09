import 'package:mobx/mobx.dart';
import 'package:sticker_fun/controllers/status_ext.dart';
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/repositories/api/api_categorias.dart';
import 'package:sticker_fun/repositories/api/api_produtos.dart';

part 'produto_controller.g.dart';

class ProdutoController = _ProdutoController with _$ProdutoController;

abstract class _ProdutoController with Store {
  final _apiProdutos = ApiProdutos();
  int _offset = 0;

  ObservableList<Produto> listMaisVendidos = ObservableList<Produto>();

  @observable
  Status status = Status.none;

  @action
  getMaisVendidos() async {
    try {
      status = Status.loading;
      List<Produto> list = await _apiProdutos.getMaisVendidos();
      listMaisVendidos.addAll(list);
      status = Status.success;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }
}
