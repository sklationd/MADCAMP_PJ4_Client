import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kaistal/login.dart';
import 'package:kaistal/main.dart';

void main() => runApp(MaterialApp(
      home: SplashApp(),
    ));

class SplashApp extends StatefulWidget {
  _SplashApp createState() => _SplashApp();
}

class _SplashApp extends State<SplashApp> {
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
              builder: (context) => Main(),
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
