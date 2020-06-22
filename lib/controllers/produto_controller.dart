import 'package:mobx/mobx.dart';
import 'package:mycatalog/controllers/status_ext.dart';
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/repositories/api/api_categorias.dart';
import 'package:mycatalog/repositories/api/api_produtos.dart';

part 'produto_controller.g.dart';

class ProdutoController = _ProdutoController with _$ProdutoController;

abstract class _ProdutoController with Store {
  final _apiProdutos = ApiProdutos();
  int _offset = 0;

  ObservableList<Produto> listProdutos = ObservableList<Produto>();
  ObservableList<Produto> listMaisVendidos = ObservableList<Produto>();

  @observable
  Produto produto = Produto();

  @observable
  Status status = Status.none;

  @observable
  StatusCad statusCad = StatusCad.none;

  @action
  getProdutos(String pCodCategoria) async {
    try {
      listProdutos.clear();
      status = Status.loading;
      List<Produto> list = await _apiProdutos.getProdutos(pCodCategoria);
      listProdutos.addAll(list);
      status = Status.success;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  @action
  getMaisVendidos() async {
    try {
      listMaisVendidos.clear();
      status = Status.loading;
      List<Produto> list = await _apiProdutos.getMaisVendidos();
      listMaisVendidos.addAll(list);
      status = Status.success;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }

  @action
  setStatusCad(StatusCad pStatus){
    statusCad = pStatus;
  }

  @action
  Future<Produto> updateProduto(Produto p) async {
    try {
      produto = null;
      status = Status.loading;
      produto = await _apiProdutos.insertProduto(p);

      status = Status.success;
      return produto;
    } catch (e) {
      status = Status.error;
      throw e.toString();
    }
  }
}
