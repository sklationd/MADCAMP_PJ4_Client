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

class _SplashApp extends State<SplashApp> with TickerProviderStateMixin {
  bool isLogin = false;
  AnimationController _controller;
  Animation<double> _animation;

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
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
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
    return Container(
      color: Colors.white,
      child: ScaleTransition(
          scale: _animation,
          alignment: Alignment.center,
          child: Image.asset('assets/cuteBird.png')
//      body: Center(
//        child: Image.asset(
//          'assets/cuteBird.png'
//        ),
//      ),
          ),
    );
  }
}
