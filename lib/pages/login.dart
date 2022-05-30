import 'dart:developer';

import 'package:fixit/layout/baseScrollLayout.dart';
import 'package:fixit/layout/mainLayout.dart';
import 'package:fixit/pages/home.dart';
import 'package:fixit/pages/signUp.dart';
import 'package:fixit/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fixit/util/route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class Login extends StatefulWidget {
//   const Login({Key? key}) : super(key: key);

//   @override
//   State<Login> createState() => _LoginState();
// }

class Login extends ConsumerWidget {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  login(context, ref) async{
    var isLoginSuccess = await Auth.login(emailCont.text, passwordCont.text);
    if(isLoginSuccess) {
      // var data = await Auth.getUserData();
      // print("[data] ${data.name}");
      // ref.watch(userProvider).name = data.name;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainLayout() ));
      }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/logo.png', height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text("Login now to continue"),
                    ],
                  ),
                )
              ],
            ),
          ),
          Image.asset(
            'assets/images/illustration1.png',
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextField(
              controller: emailCont,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: "Email Address",
              ),
            ),
          ),
          TextField(
            controller: passwordCont,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              labelText: "Password",
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => {},
                        child: const Text("Forget password?")),
                  ],
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () { login(context, ref);},
                  child: const Text("Login"),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Nav.goTo(context, const SignUp());
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
