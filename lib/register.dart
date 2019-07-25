import 'package:flutter/material.dart';
import 'package:kaistal/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:kaistal/main.dart';
import 'package:kaistal/dialog.dart';
import 'package:kaistal/profileimageview.dart';

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
            SizedBox(
              height: 45,
              child: TextField(
                focusNode: _idFocus,
                controller: _usernameController,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  filled: true,
                  labelText: 'Username',
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(context, _idFocus, _fstFocus);
                },
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height:45,
              child: TextField(
                focusNode: _fstFocus,
                controller: _firstnameController,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  filled: true,
                  labelText: 'First name',
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(context, _fstFocus, _lastFocus);
                },
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 45,
              child: TextField(
                focusNode: _lastFocus,
                controller: _lastnameController,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  filled: true,
                  labelText: 'Last name',
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(context, _lastFocus, _phoneFocus);
                },
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 45,
              child: TextField(
                focusNode: _phoneFocus,
                controller: _phoneController,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  filled: true,
                  labelText: 'Phone number',
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(context, _phoneFocus, _emailFocus);
                },
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 45,
              child: TextField(
                focusNode: _emailFocus,
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  filled: true,
                  labelText: 'E-mail',
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(context, _emailFocus, _pwFocus);
                },
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 45,
              child: TextField(
                focusNode: _pwFocus,
                controller: _passwordController,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
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
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 45,
              child: TextField(
                focusNode: _pwcfFocus,
                controller: _passwordConfirmationController,
                decoration: InputDecoration(
                    enabledBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.orangeAccent, width: 2.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.orangeAccent, width: 2.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    filled: true,
                    labelText: 'Password Confirm',
                ),
                obscureText: true,
                // 가려짐
                textInputAction: TextInputAction.done,
                onSubmitted: (term) {
                  _pwcfFocus.unfocus();
                  _register(
                          context,
                          _usernameController.text,
                          _firstnameController.text,
                          _lastnameController.text,
                          _phoneController.text,
                          _emailController.text,
                          _passwordController.text,
                          _passwordConfirmationController.text)
                      .then((result) {
                    if (result) {
                      _registerSuccess(context);
                    } else {
                      print("Register Failed");
                    }
                  });
                },
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
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
                        _firstnameController.clear();
                        _lastnameController.clear();
                        _phoneController.clear();
                        _emailController.clear();
                        _passwordConfirmationController.clear();
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
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
                        _register(
                                context,
                                _usernameController.text,
                                _firstnameController.text,
                                _lastnameController.text,
                                _phoneController.text,
                                _emailController.text,
                                _passwordController.text,
                                _passwordConfirmationController.text)
                            .then((result) {
                          if (result) {
                            _registerSuccess(context);
                          } else {
                            print("Register Failed");
                          }
                        });
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
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

  ///RESTful API 이용해서 가입하고 성공하면 로그인 후 저장
  Future<bool> _register(
      BuildContext context,
      String username,
      String firstname,
      String lastname,
      String phone,
      String email,
      String password,
      String passwordConfirmation) async {
    Register registerSession = new Register(username, firstname, lastname,
        phone, email, password, passwordConfirmation);
    bool result = await registerSession.getData();
    if (result) {
      // Register Success
      await _login(context, username, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("phone", phone);
      prefs.setString("name", firstname + ' ' + lastname);
      prefs.setString("email", email);
      return true;
    } else
      return false;
  }

  void _registerSuccess(BuildContext context) {
    showAlertDialog(context, () {
      ///set profile image to default
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
      );
    }, () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileImageView(),
        ),
      );
    }, "프로필 사진 등록", "프로필 사진을 등록하시겠습니까?");
  }

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
