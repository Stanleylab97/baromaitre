import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl =
      "https://baroplux.com/api";
  var log = Logger();

  FlutterSecureStorage storage = FlutterSecureStorage();

  Future getAccountStatus(var url,String token) async {
    url = formater(url);
    var response = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }



    Future<http.Response> getTokenFromBaroplux(var url, Map<String, String> body) async {

      url = formater(url);
      var response = await http.post(
        url,
        body: json.encode(body),
        headers: {"Content-type": "application/json"},
      );
      log.i(response.body);
      log.i(response.statusCode);
      return response;
    }

  Future<http.Response> checkMatricule(var url, String token) async {

    url = formater(url);
    var response = await http.get(url,headers: {"Content-type": "application/json", "Authorization": "Bearer $token"});
    log.i(response.body);
    //log.i(response.statusCode);
    return response;
  }

/*   Future get(String url) async {
    // String token = await storage.read(key: "token");
    url = formater(url);

    // /user/register
    var response = await http.get(url); //,headers: {"Authorization": "Bearer $token"},
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }
 */
  Future<http.Response> post(var url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    var response = await http.post(
      url,
      body: json.encode(body),
      headers: {"Content-type": "application/json"},
    );
    return response;
  }

  Uri formater(String url) {
    return Uri.parse(baseurl + url);
  }

  NetworkImage getImage(String username) {
    Uri url = formater("/uploads//$username.jpg");
    return NetworkImage(url.toString());
  }
}