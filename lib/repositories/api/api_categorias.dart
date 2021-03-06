import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mycatalog/models/categoria.dart';
import 'package:mycatalog/utils/constants.dart';
import 'dart:convert';
import '../../models/categoria.dart';
import '../CustomException.dart';
import 'api_base.dart';

class ApiCategorias extends ApiBase {
  Future<List<Categoria>> getCategorias(int offset) async {
    Uri uri = Uri.http(Constants.URL_BASE, Constants.URL_CATEGORIAS);

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);

      List<Categoria> listCategoria =
          responseJson.map((i) => Categoria.fromJson(i)).toList();

      return listCategoria;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Categoria> updateCategoria(Categoria categoria) async {
    Uri uri = Uri.http(Constants.URL_BASE, Constants.URL_UPDATE_CATEGORIA);

    String s = json.encode(categoria);

    try {
      final response = await http
          .post(uri, body: s, headers: headers)
          .timeout(Duration(seconds: timeOut));
      Map responseJson = _response(response);

      Categoria categoria = Categoria.fromJson(responseJson);

      return categoria;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw Exception(e);
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
