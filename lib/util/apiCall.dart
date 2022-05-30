import 'dart:convert';
import 'package:fixit/util/constants.dart';
import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  static Map<String,String> headers = {
    "Accept": "application/json"
  };
  static post(String url, Map body) async{
    var response = await http.post(Uri.parse(url),headers: headers, body: body);
    if(response.statusCode!=200){
      throw Exception("request error: ${response.statusCode} error | ${response.body}");
    }
    return jsonDecode(response.body);  
  }
  static get(String url) async{
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: tokenKey);
    headers["Authorization"] = "Bearer $token";
    var response = await http.get(Uri.parse(url),headers: headers);
    if(response.statusCode!=200){
      throw Exception("request error: ${response.statusCode} error | ${response.body}");
    }
    return jsonDecode(response.body);  
  }
}