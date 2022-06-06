import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/pages/login.dart';
import 'package:fixit/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ScrollLayout(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Profile"),
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
                    "Idris AKbar Adyusman",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Alamat anda"),
                  Text("alamat user",style: TextStyle(fontSize: 20),),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kontak"),
                  Text("Nomor Kontak",style: TextStyle(fontSize: 20),),
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
  }
}
