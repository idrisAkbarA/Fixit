import 'package:fixit/models/userModel.dart';
import 'package:fixit/services/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var user = UserModel(id: 0, name: null, email: null, phone: null, role: null );
var userProvider = FutureProvider<UserModel>((ref)async{
  var data = await Auth.getUserData();
  return data;
  });