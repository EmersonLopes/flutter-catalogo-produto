import 'dart:convert';

abstract class ApiBase{
  int timeOut = 10;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Basic ' + base64Encode(utf8.encode('administrador:789'))
  };
}