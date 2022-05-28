import 'package:flutter/material.dart';

class Nav{
  static void goTo(context, Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
  }
}