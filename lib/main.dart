import 'package:flutter/material.dart';

// Firebase
import 'package:login_demo/authentication.dart';

import 'package:login_demo/rootpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DOCS APP',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),

        // Passing the Firebase Auth
        home: new Rootpage(auth: new Auth()));
  }
}
