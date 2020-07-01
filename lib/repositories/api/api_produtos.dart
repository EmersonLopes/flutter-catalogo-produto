import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mycatalog/models/produto.dart';
import 'package:mycatalog/utils/constants.dart';
import 'dart:convert';

import '../CustomException.dart';
import 'api_base.dart';

class ApiProdutos extends ApiBase {
  Future<List<Produto>> getProdutos(String pCodCategoria) async {
    Uri uri =
        Uri.http(Constants.URL_BASE, Constants.URL_PRODUTOS + pCodCategoria);

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);

      List<Produto> list =
          responseJson.map((i) => Produto.fromJson(i)).toList();

      return list;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Produto>> getProdutosDescricao(String pDescricao) async {
    Uri uri =
        Uri.http(Constants.URL_BASE, Constants.URL_PRODUTOS_DESC + pDescricao);

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);
      print(responseJson);

      List<Produto> list =
          responseJson.map((i) => Produto.fromJson(i)).toList();
      if (list[0].codProduto == null) list.clear();

      return list;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Produto>> getMaisVendidos() async {
    Uri uri = Uri.http(Constants.URL_BASE, Constants.URL_MAIS_VENDIDOS);

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);

      List<Produto> list =
          responseJson.map((i) => Produto.fromJson(i)).toList();

      return list;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Produto>> getPromocoes() async {
    Uri uri = Uri.http(Constants.URL_BASE, Constants.URL_PROMOCOES);

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);
      List<Produto> list =
          responseJson.map((i) => Produto.fromJson(i)).toList();

      return list;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Produto> insertProduto(Produto produto) async {
    Uri uri = Uri.http(Constants.URL_BASE, Constants.URL_POST_PRODUTO);

    try {
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(produto))
          .timeout(Duration(seconds: timeOut));
      var responseJson = _response(response);

      Produto prod = Produto.fromJson(responseJson);

      return prod;
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
