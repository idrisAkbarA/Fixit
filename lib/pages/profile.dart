import 'dart:convert';

import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/models/userModel.dart';
import 'package:fixit/pages/editProfile.dart';
import 'package:fixit/pages/login.dart';
import 'package:fixit/services/auth.dart';
import 'package:fixit/util/constants.dart';
import 'package:fixit/util/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  logout(context) async {
    await Auth.logout();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }

  late Future<UserModel> _user;

  Future<UserModel> getUser() async {
    var storage = const FlutterSecureStorage();
    var rawJsonData = await storage.read(key: userDataKey);

    return UserModel.fromJson(jsonDecode(rawJsonData!));
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
                TextButton(onPressed: (){
                  Nav.goTo(context, EditUserProfile());
                }, child: Text("Perbarui data diri")),
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
                            "${snapshot.data.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Alamat anda"),
                          Text(
                            "${snapshot.data.address}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kontak"),
                          Text(
                            "${snapshot.data.phone}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email"),
                          Text(
                            "${snapshot.data.email}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          logout(context);
                        },
                        child: const Text("Logout"),
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
