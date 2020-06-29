import 'package:flutter/material.dart';
// import 'login_signup_page.dart';
import 'package:login_demo/authentication.dart';
import 'package:login_demo/rootpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'DOCS APP',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Rootpage(auth: new Auth()));
  }
}
