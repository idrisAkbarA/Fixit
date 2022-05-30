import 'package:fixit/models/userModel.dart';
import 'package:fixit/pages/home.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/constants.dart';
import 'package:fixit/util/route.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:fixit/util/endpoint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fixit/providers/userProvider.dart';

class Auth {
  static Future<bool> login(String email, String password) async {
    var body = {'email': email, 'password': password};

    try {
      var response = await Api.post(Endpoint.login, body);
      final storage = new FlutterSecureStorage();
      await storage.write(key: tokenKey, value: response['data']['token']);
      await storage.write(key: userDataKey, value: jsonEncode( response['data']['user']));

      print(response['data']['token']);
      print("[Auth] ${response['data']['user']}");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  static Future<bool> isLoggedIn() async{
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: tokenKey);
    if(token == null){
      return false;
    }
    return true;
  }
  static Future<bool> logout() async{
    final storage = new FlutterSecureStorage();
    await storage.delete(key: tokenKey);
    print("[Auth]${await storage.read(key: tokenKey)}");
    return true;
  }
  static Future<UserModel> getUserData() async{
    final storage = new FlutterSecureStorage();
    var data = await storage.read(key: userDataKey);
    if(data!=null){
      return UserModel.fromJson(jsonDecode(data));
    }
    return UserModel();
  }
  static Future<bool> register(name, email, password, confirmPassword) async{
    var body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword
    };
    try {
      var response = await Api.post(Endpoint.register, body);
      final storage = new FlutterSecureStorage();
      await storage.write(key: tokenKey, value: response['data']['token']);
      // await storage.write(key: userDataKey, value: jsonEncode( response['data']['user']));

      print("[Register] ${response['data']['token']}");
      return true;
    } catch (e) {
      print("error ${e.toString()}");
      throw Exception(e);
    }
  }
}
