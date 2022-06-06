import 'dart:convert';

import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/models/userModel.dart';
import 'package:fixit/pages/login.dart';
import 'package:fixit/pages/profile.dart';
import 'package:fixit/services/auth.dart';
import 'package:fixit/util/apiCall.dart';
import 'package:fixit/util/constants.dart';
import 'package:fixit/util/endpoint.dart';
import 'package:fixit/util/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  logout(context) async {
    await Auth.logout();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }

  update() async{
    var body = {
      "name": nameCont.text,
      "address": addressCont.text,
      "email": emailCont.text,
      "phone": phoneCont.text
    };
    try {
      var response = await Api.post(Endpoint.updateUser, body, useToken: true);
      var storage = const FlutterSecureStorage();
      await storage.write(key: userDataKey, value:jsonEncode(response['data']['user']));
      print("[update] $response");
      setState(() {
        
      });
         Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfile(),
        ),
        (route) => false);
    } catch (e) {
      print("$e");
    }
  }

  TextEditingController emailCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  late Future<UserModel> _user;

  Future<UserModel> getUser() async {
    var storage = const FlutterSecureStorage();
    var rawJsonData = await storage.read(key: userDataKey);
    var user = UserModel.fromJson(jsonDecode(rawJsonData!));
    nameCont.text = user.name ?? "";
    emailCont.text = user.email ?? "";
    addressCont.text = user.address ?? "";
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _user,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return ScrollLayout(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Profile"),
                // TextButton(onPressed: () {}, child: Text("Perbarui data diri")),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const GFAvatar(
                            size: 70,
                            backgroundImage: NetworkImage(
                                "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/circular--1--1.png")),
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "${nameCont.text}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextField(
                    controller: nameCont,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: "Nama anda",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextField(
                    controller: addressCont,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: "Alamat anda",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextField(
                    controller: phoneCont,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: "Kontak anda",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextField(
                    controller: emailCont,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: "Email anda",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async{
                          update();
                        },
                        child: const Text("Simpan"),
                      )),
                ),
              ],
            ));
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
