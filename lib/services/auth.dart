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
    final storage = new FlutterSecureStorage();
    var deviceToken = await storage.read(key: deviceTokenKey);
    var body = {
      'email': email,
      'password': password,
      'device_token': deviceToken
    };
    print("[login] token: ${body['device_token']}");
    try {
      var response = await Api.post(Endpoint.login, body);

      print("[auth] ${response['data']['partner']}");
      var partner = response['data']['partner'];
      await storage.write(key: tokenKey, value: response['data']['token']);
      await storage.write(
          key: userDataKey, value: jsonEncode(response['data']['user']));
      if (partner != null) {
        await storage.write(
            key: partnerIdKey,
            value: response['data']['partner']['id'].toString());
      }
      print(response['data']['token']);
      print("[Auth] ${response['data']['user']}");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: tokenKey);
    if (token == null) {
      return false;
    }
    return true;
  }

  static Future<bool> logout() async {
    var body = {};
    try {
      await Api.post(Endpoint.logout, body, useToken: true);
    } catch (e) {
      print("$e");
    }
    final storage = new FlutterSecureStorage();
    await storage.delete(key: tokenKey);
    await storage.delete(key: partnerIdKey);
    print("[Auth]${await storage.read(key: tokenKey)}");
    return true;
  }

  static Future<UserModel> getUserData() async {
    final storage = new FlutterSecureStorage();
    var data = await storage.read(key: userDataKey);
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    }
    return UserModel();
  }

  static Future<bool> register(name, email, password, confirmPassword) async {
    final storage = new FlutterSecureStorage();
    var deviceToken = await storage.read(key: deviceTokenKey);
    var body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'device_token': deviceToken
    };
    try {
      var response = await Api.post(Endpoint.register, body);
      await storage.write(key: tokenKey, value: response['data']['token']);
      // await storage.write(key: userDataKey, value: jsonEncode( response['data']['user']));

      print("[Register] ${response['data']['token']}");
      return true;
    } catch (e) {
      print("error ${e.toString()}");
      throw Exception(e);
    }
  }

  static Future<int> registerAsPartner(
      namaToko, alamat, phone, deskripsi) async {
    print("[register] I'm called");
    var body = {
      'name': namaToko,
      'address': alamat,
      'description': deskripsi,
      'phone': phone
    };
    try {
      var response =
          await Api.post(Endpoint.registerAsPartner, body, useToken: true);
      final storage = new FlutterSecureStorage();
      await storage.write(
          key: partnerIdKey, value: response['data']['partner_id'].toString());
      // await storage.write(key: userDataKey, value: jsonEncode( response['data']['user']));

      print("[Register] ${response['data']['partner_id']}");
      return response['data']['partner_id'];
    } catch (e) {
      print("error ${e.toString()}");
      throw Exception(e);
    }
  }
}
