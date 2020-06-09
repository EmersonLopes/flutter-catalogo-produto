import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sticker_fun/models/categoria.dart';
import 'package:sticker_fun/utils/constants.dart';
import 'dart:convert';

import '../CustomException.dart';

class ApiCategorias {
  final int _timeOut = 10;

  Future<List<Categoria>> getCategorias(int offset) async {

    Uri uri =
        Uri.http(Constants.URL_BASE, Constants.URL_CATEGORIAS);
    print("URI>>> ${uri.toString()}");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: _timeOut));
      List responseJson = _response(response);
      print("RESPONSE>>> ${response.body}");
      List<Categoria> listCategoria =  responseJson.map((i)=> Categoria.fromJson(i)).toList();


      return listCategoria;
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
