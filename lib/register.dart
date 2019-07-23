import 'package:flutter/material.dart';
import 'package:kaistal/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:kaistal/main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();
  final FocusNode _pwcfFocus = FocusNode();
  final FocusNode _fstFocus = FocusNode();
  final FocusNode _lastFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            TextField(
              focusNode: _idFocus,
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _idFocus, _fstFocus);
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              focusNode: _fstFocus,
              controller: _firstnameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'First name',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _fstFocus, _lastFocus);
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              focusNode: _lastFocus,
              controller: _lastnameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Last name',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _lastFocus, _phoneFocus);
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              focusNode: _phoneFocus,
              controller: _phoneController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Phone Number',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _phoneFocus, _emailFocus);
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              focusNode: _emailFocus,
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Email',
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (term) {
                _fieldFocusChange(context, _emailFocus, _pwFocus);
              },
            ),
            SizedBox(height: 8.0),
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
            SizedBox(height: 8.0),
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
                _register(context,
                    _usernameController.text,
                    _firstnameController.text,
                    _lastnameController.text,
                    _phoneController.text,
                    _emailController.text,
                    _passwordController.text,
                    _passwordConfirmationController.text)
                    .then((result) {
                  if (result) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context) => Main(),
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
                    _firstnameController.clear();
                    _lastnameController.clear();
                    _phoneController.clear();
                    _emailController.clear();
                    _passwordConfirmationController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('확인'),
                  onPressed: () {
                    _register(context,
                        _usernameController.text,
                        _firstnameController.text,
                        _lastnameController.text,
                        _phoneController.text,
                        _emailController.text,
                        _passwordController.text,
                        _passwordConfirmationController.text)
                        .then((result) {
                      if (result) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(
                            builder: (context) => Main(),
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
  Future<bool> _register(BuildContext context, String username, String firstname, String lastname, String phone, String email,  String password,
      String passwordConfirmation) async {
    print(username);
    print(firstname);
    print(lastname);
    print(phone);
    print(email);
    print(password);
    print(passwordConfirmation);    Register registerSession =
        new Register(username, firstname, lastname, phone, email, password, passwordConfirmation);
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
      prefs.setString("phone", phone);
      prefs.setString("name", firstname + ' ' + lastname);
      prefs.setString("email", email);
      return true;
    } else
      return false;
  }
}
