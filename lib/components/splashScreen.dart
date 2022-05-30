import 'dart:async';
import 'package:fixit/layout/mainLayout.dart';
import 'package:flutter/material.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import 'package:fixit/services/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveNextPage();
  }

  moveNextPage() async{
    var isLoggedIn = await Auth.isLoggedIn();
    print("[Auth] $isLoggedIn}");
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => isLoggedIn? MainLayout(): Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}