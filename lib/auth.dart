import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  String username;
  String password;

  Login(String _username, String _password) {
    username = _username;
    password = _password;
  }

  Future<String> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull('http://52.78.7.28:8080/login'),
      headers: {"Accept": "application/json"},
      body: {'username': username, 'password': password},
    );
    print(response.body);
    var data = json.decode(response.body);

    SharedPreferences sf = await SharedPreferences.getInstance();
    assert(data['user'].length == 1);
    print(data['user'][0]['firstname']+' '+data['user'][0]['lastname']);
    print(data['user'][0]['phone']);
    print(data['user'][0]['email']);
    sf.setString("name", data['user'][0]['firstname']+' '+data['user'][0]['lastname']);
    sf.setString("phone",data['user'][0]['phone']);
    sf.setString("email",data['user'][0]['email']);

    return data['token'];
    ///만약 성공하면 TOKEN 돌려주고, 실패하면 실패 메시지 출력하고 null 리턴
  }
}

class Register {
  String username;
  String firstname;
  String lastname;
  String phone;
  String email;
  String password;
  String passwordConfirmation;

  Register(String _username, String _firstname, String _lastname, String _phone, String _email, String _password, String _passwordConfirmation) {
    username = _username;
    firstname = _firstname;
    lastname = _lastname;
    phone = _phone;
    email = _email;
    password = _password;
    passwordConfirmation = _passwordConfirmation;
  }

  Future<bool> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull('http://52.78.7.28:8080/users/'),
      headers: {"Accept": "application/json"},
      body:
      {
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'phonenumber': phone,
        'email': email,
        'password': password,
        'confirmPassword': passwordConfirmation
      },
    );
    var data = json.decode(response.body);
    String body = response.body;
    return data['id'] != null;
    ///만약 성공하면 true 돌려주고, 실패하면 실패 메시지 출력하고 false 리턴
  }
}
