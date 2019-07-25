import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:kaistal/auth.dart';
import 'package:kaistal/register.dart';
import 'package:kaistal/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            SizedBox(height: 150.0,
            child: Center(child: Image.asset('assets/cuteBird.png'))),
            SizedBox(height: 40.0),
            TextField(
              focusNode: _idFocus,
              controller: _usernameController,
              decoration: InputDecoration(
                enabledBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                focusedBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                filled: true,
                labelText: 'Username',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _idFocus, _pwFocus);
              },
            ),
            SizedBox(height: 12.0),
            TextField(
              focusNode: _pwFocus,
              controller: _passwordController,
              decoration: InputDecoration(
                enabledBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                focusedBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
              // 가려짐
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                _pwFocus.unfocus();
                _login(context, _usernameController.text,
                        _passwordController.text)
                    .then((result) {
                  if (result) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Main(),
                      ),
                    );
                  } else {
                    print("Login Failed");
                  }
                });
              },
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    child: RaisedButton(
                      color: Colors.orangeAccent,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.clear, color: Colors.white),
                          SizedBox(width: 30),
                          Text(
                            'CLEAR',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _usernameController.clear();
                        _passwordController.clear();
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 150,
                    child: RaisedButton(
                        color: Colors.orangeAccent,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 30),
                            Text(
                              'SIGN IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _login(context, _usernameController.text,
                                  _passwordController.text)
                              .then((result) {
                            if (result) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Main(),
                                ),
                              );
                            } else {
                              print("Login Failed");
                            }
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 150,
                    child: RaisedButton(
                        color: Colors.orangeAccent,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.person_add, color: Colors.white),
                            SizedBox(width: 30),
                            Text(
                              'SIGN UP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Textfield Focus 변경
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  ///RESTful API 이용해서 로그인하고 성공하면 TOKEN 저장
  Future<bool> _login(
      BuildContext context, String username, String password) async {
    Login loginSession = new Login(username, password);
    String token = await loginSession.getData();
    if (token != null) {
      // Login Success
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
      prefs.setString("username", username);
      prefs.setString("password", password);
      return true;
    } else
      return false;
  }
}
