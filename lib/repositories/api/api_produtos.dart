import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/models/produto.dart';
import 'package:sticker_fun/utils/constants.dart';
import 'dart:convert';

import '../CustomException.dart';
import 'api_base.dart';

class ApiProdutos extends ApiBase {

  Future<List<Produto>> getProdutos(String pCodCategoria) async {

    Uri uri =
    Uri.http(Constants.URL_BASE, Constants.URL_PRODUTOS+pCodCategoria);
    print("URI>>> ${uri.toString()}");

    try {
      final response = await http.get(uri, headers: headers).timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);
      print("RESPONSE>>> ${response.body}");
      List<Produto> list =  responseJson.map((i)=> Produto.fromJson(i)).toList();


      return list;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<Produto>> getMaisVendidos() async {

    Uri uri =
        Uri.http(Constants.URL_BASE, Constants.URL_MAIS_VENDIDOS);
    print("URI>>> ${uri.toString()}");

    try {
      final response = await http.get(uri, headers: headers).timeout(Duration(seconds: timeOut));
      List responseJson = _response(response);
      print("RESPONSE>>> ${response.body}");
      List<Produto> list =  responseJson.map((i)=> Produto.fromJson(i)).toList();


      return list;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }catch(e){
      throw Exception(e);
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
//        print(responseJson);
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
