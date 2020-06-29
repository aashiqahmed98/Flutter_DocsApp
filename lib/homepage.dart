import 'package:flutter/material.dart';
import 'package:login_demo/authentication.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final String userId;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DOCS APP"),
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              child: new Text(
                'Logout',
                style: new TextStyle(fontSize: 17, color: Colors.white),
              ))
        ],
      ),
      body: new Container(
        child: new Text("Hello " + userId),
      ),
    );
  }
}
