import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class ScrollLayout extends StatefulWidget {
  final Widget child;
  const ScrollLayout({required this.child, Key? key}) : super(key: key);
  @override
  State<ScrollLayout> createState() => _ScrollLayoutState();
}

class _ScrollLayoutState extends State<ScrollLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 2),
                child: widget.child,
              ),
            )
            )
          ),
      ),
    );
  }
}