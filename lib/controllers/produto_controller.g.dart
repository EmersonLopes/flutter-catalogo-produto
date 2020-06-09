// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProdutoController on _CategoriaController, Store {
  final _$statusAtom = Atom(name: '_CategoriaController.status');

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

  final _$getMaisVendidosAsyncAction = AsyncAction('getMaisVendidos');

  @override
  Future getMaisVendidos() {
    return _$getMaisVendidosAsyncAction.run(() => super.getMaisVendidos());
  }

  @override
  String toString() {
    final string = 'status: ${status.toString()}';
    return '{$string}';
  }
}
