import 'package:flutter/material.dart';

import 'package:login_demo/login_signup_page.dart';
import 'package:login_demo/authentication.dart';
import 'package:login_demo/homepage.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Rootpage extends StatefulWidget {
  // Rootpage({Key key}) : super(key: key);

  // From the main.dart
  Rootpage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

// This state is for maintaining persistance
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid; // ?. is a membership operator
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        // return buildWaitingScreen();
        print("Auth status not determined");
        break;

      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;

      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: logoutCallback,
          );
        }
        break;
    }
  }
}
