import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kaistal/contentsview.dart';
import 'package:kaistal/login.dart';

void main() => runApp(MaterialApp(
      home: MainApp(),
    ));

class MainApp extends StatefulWidget {
  _MainApp createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _isLoggedin().then((isLogin) {
        if (isLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ContentsView(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
      });
    });
  }

  Future<bool> _isLoggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size:400,
        ),
      ),
    );
  }
}
