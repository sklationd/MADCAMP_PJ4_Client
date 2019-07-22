import 'package:flutter/material.dart';
import 'package:kaistal/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:kaistal/contentsview.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();
  final FocusNode _pwcfFocus = FocusNode();

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
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _pwFocus, _pwcfFocus);
              },
            ),
            SizedBox(height: 12.0),
            TextField(
              focusNode: _pwcfFocus,
              controller: _passwordConfirmationController,
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Password Confirmation',
                  errorText: (_passwordConfirmationController.text !=
                          _passwordController.text)
                      ? "Password Confirmation does not matched"
                      : null),
              obscureText: true,
              // 가려짐
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                _pwcfFocus.unfocus();
                _register(context, _usernameController.text,
                        _passwordController.text, _passwordConfirmationController.text)
                    .then((result) {
                  if (result) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context) => ContentsView(),
                      ),
                    );
                  } else {
                    print("Register Failed");
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
                    _passwordConfirmationController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('확인'),
                  onPressed: () {
                    _register(context, _usernameController.text,
                        _passwordController.text,
                        _passwordConfirmationController.text)
                        .then((result) {
                      if (result) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(
                            builder: (context) => ContentsView(),
                          ),
                        );
                      } else {
                        print("Register Failed");
                      }
                    });
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

  ///RESTful API 이용해서 가입하고 성공하면 로그인 후 저장
  Future<bool> _register(BuildContext context, String username, String password,
      String passwordConfirmation) async {
    Register registerSession =
        new Register(username, password, passwordConfirmation);
    bool result = await registerSession.getData();
    if (result) {
      // Register Success
      Login loginSession = new Login(username, password);
      String token = await loginSession.getData();
      assert(token != null);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
      prefs.setString("username", username);
      prefs.setString("password", password);
      return true;
    } else
      return false;
  }
}
