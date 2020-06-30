import 'package:flutter/material.dart';
import 'package:login_demo/authentication.dart';

import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final String userId;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();

      Fluttertoast.showToast(
          msg: "Logout Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
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
                style: new TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: new Container(
          // child: new Text("Hello " + userId,
          //     style: new TextStyle(
          //         fontSize: 20.0,
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold)),
          child: new RichText(
        text: new TextSpan(
          text: 'Hello ',
          style: new TextStyle(fontSize: 18, color: Colors.black),
          children: <TextSpan>[
            new TextSpan(
                text: userId + " (UID)",
                style:
                    new TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      )),
    );
  }
}
