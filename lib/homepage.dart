import 'package:flutter/material.dart';
import 'package:login_demo/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:bubble/bubble.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final String userId;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();

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

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    var status = await Permission.microphone.status;
    print(status);
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
      Permission.microphone.request();
    }
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  List<String> litems = ["Tap the mic!", "Im here to Help!"];

  @override
  Widget build(BuildContext context) {
    if (_hasSpeech == false) {
      initSpeechState();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DOCS APP'),
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
        body: new ListView.builder(
            itemCount: litems.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                child: Column(
                  children: [
                    Align(
                        alignment: index % 2 == 0
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: index % 2 == 0
                            ? Text(
                                "You",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Text("Doctor",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.italic))),
                    new Bubble(
                      margin: BubbleEdges.only(top: 10),
                      alignment: index % 2 == 0
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      nip: index % 2 == 0
                          ? BubbleNip.rightBottom
                          : BubbleNip.leftBottom,
                      color: Color.fromRGBO(225, 255, 199, 1.0),
                      child: Text(
                        '${litems[index]}',
                        textAlign: TextAlign.right,
                        textScaleFactor: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            }),
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          child: speech.isNotListening == true
              ? FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed:
                      !_hasSpeech || speech.isListening ? null : startListening,
                )
              : FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  onPressed: null,
                  label: Text("Listening...")),
        ),
      ),
    );
  }

  void startListening() {
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      if (result.finalResult == true) {
        lastWords = "${result.recognizedWords} - ${result.finalResult}";
        litems.add(result.recognizedWords);
      }
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    print("sprintound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
