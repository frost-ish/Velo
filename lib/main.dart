import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:velo/HomePage/main.dart';
import 'package:velo/SignInPage/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: HomePage()),
    );
  }
}
