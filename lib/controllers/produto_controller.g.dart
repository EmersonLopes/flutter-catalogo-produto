// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProdutoController on _ProdutoController, Store {
  final _$statusAtom = Atom(name: '_ProdutoController.status');

  @override
  Status get status {
    _$statusAtom.context.enforceReadPolicy(_$statusAtom);
    _$statusAtom.reportObserved();
    return super.status;
  }

  @override
  set status(Status value) {
    _$statusAtom.context.conditionallyRunInAction(() {
      super.status = value;
      _$statusAtom.reportChanged();
    }, _$statusAtom, name: '${_$statusAtom.name}_set');
  }

  final _$statusCadAtom = Atom(name: '_ProdutoController.statusCad');

  @override
  StatusCad get statusCad {
    _$statusCadAtom.context.enforceReadPolicy(_$statusCadAtom);
    _$statusCadAtom.reportObserved();
    return super.statusCad;
  }

  @override
  set statusCad(StatusCad value) {
    _$statusCadAtom.context.conditionallyRunInAction(() {
      super.statusCad = value;
      _$statusCadAtom.reportChanged();
    }, _$statusCadAtom, name: '${_$statusCadAtom.name}_set');
  }

  final _$getProdutosAsyncAction = AsyncAction('getProdutos');

  @override
  Future getProdutos(String pCodCategoria) {
    return _$getProdutosAsyncAction.run(() => super.getProdutos(pCodCategoria));
  }

  final _$getMaisVendidosAsyncAction = AsyncAction('getMaisVendidos');

  @override
  Future getMaisVendidos() {
    return _$getMaisVendidosAsyncAction.run(() => super.getMaisVendidos());
  }

  final _$_ProdutoControllerActionController =
      ActionController(name: '_ProdutoController');

  @override
  dynamic setStatusCad(StatusCad pStatus) {
    final _$actionInfo = _$_ProdutoControllerActionController.startAction();
    try {
      return super.setStatusCad(pStatus);
    } finally {
      _$_ProdutoControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'status: ${status.toString()},statusCad: ${statusCad.toString()}';
    return '{$string}';
  }
}
