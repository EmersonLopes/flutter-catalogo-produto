// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CategoriaController on _CategoriaController, Store {
  final _$imageAtom = Atom(name: '_CategoriaController.image');

  @override
  File get image {
    _$imageAtom.context.enforceReadPolicy(_$imageAtom);
    _$imageAtom.reportObserved();
    return super.image;
  }

  @override
  set image(File value) {
    _$imageAtom.context.conditionallyRunInAction(() {
      super.image = value;
      _$imageAtom.reportChanged();
    }, _$imageAtom, name: '${_$imageAtom.name}_set');
  }

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

  final _$getCategoriasAsyncAction = AsyncAction('getCategorias');

  @override
  Future getCategorias() {
    return _$getCategoriasAsyncAction.run(() => super.getCategorias());
  }

  final _$_CategoriaControllerActionController =
      ActionController(name: '_CategoriaController');

  @override
  dynamic setImage(File img) {
    final _$actionInfo = _$_CategoriaControllerActionController.startAction();
    try {
      return super.setImage(img);
    } finally {
      _$_CategoriaControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'image: ${image.toString()},status: ${status.toString()}';
    return '{$string}';
  }
}
