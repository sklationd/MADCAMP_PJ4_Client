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
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('Hello'),
              ],
            ),
            SizedBox(height: 120.0),
            TextField(
              focusNode: _idFocus,
              controller: _usernameController,
              decoration: InputDecoration(
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
                    Navigator.pushReplacement(context,
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
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CLEAR'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('SIGN IN'),
                  onPressed: () {
                    _login(context, _usernameController.text,
                            _passwordController.text)
                        .then((result) {
                      if (result) {
                        Navigator.pushReplacement(context,
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
                RaisedButton(
                  child: Text('SIGN UP'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                ),
              ],
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
