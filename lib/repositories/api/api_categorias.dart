import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sticker_fun/models/gif.dart';
import 'package:sticker_fun/models/giphy.dart';
import 'package:sticker_fun/utils/constants.dart';
import 'dart:convert';

import '../CustomException.dart';

class ApiGiphy {
  final int _timeOut = 10;

  Future<Giphy> getTrending(int offset) async {
    var queryParameters = {
      'api_key': Constants.API_KEY,
      'offset': offset.toString()
    };

    Uri uri =
        Uri.https(Constants.URL_BASE, Constants.URL_TRENDING, queryParameters);
    print("URI>>> ${uri.toString()}");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: _timeOut));
      var responseJson = _response(response);
      print("RESPONSE>>> ${response.body}");
      var giphy = Giphy.fromJson(responseJson);
      print("Giphy>>> ${giphy.toString()}");

      return giphy;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }catch(e){
      throw Exception(e);
    }
  }

  Future<Giphy> getSearch(int offset, String search, {String lang}) async {
    var queryParameters = {
      'api_key': Constants.API_KEY,
      'offset': offset.toString(),
      'q': search,
      'lang': lang
    };

    Uri uri =
        Uri.https(Constants.URL_BASE, Constants.URL_SEARCH, queryParameters);
//    print("URI>>> ${uri.toString()}");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: _timeOut));
      var responseJson = _response(response);
      var giphy = Giphy.fromJson(responseJson);

      return giphy;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<Gif> getRandom(String tag) async {
    var queryParameters = {'api_key': Constants.API_KEY, 'tag': tag};

    Uri uri =
        Uri.https(Constants.URL_BASE, Constants.URL_RANDOM, queryParameters);
    print('URI>>>$uri');

    try {
      final response = await http.get(uri).timeout(Duration(seconds: _timeOut));
      var responseJson = _response(response);
      var gif = Gif.fromJson(responseJson['data']);

      return gif;
    } on TimeoutException {
      throw FetchDataException('Timeout');
    } on SocketException {
      throw FetchDataException('No Internet connection');
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
