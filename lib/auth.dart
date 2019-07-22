import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    return data['token'];
    ///만약 성공하면 TOKEN 돌려주고, 실패하면 실패 메시지 출력하고 null 리턴
  }
}

class Register {
  String username;
  String password;
  String passwordConfirmation;

  Register(String _username, String _password, String _passwordConfirmation) {
    username = _username;
    password = _password;
    passwordConfirmation = _passwordConfirmation;
  }

  Future<bool> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull('http://52.78.7.28:8080/users/'),
      headers: {"Accept": "application/json"},
      body: {'username': username, 'password': password, 'confirmPassword': passwordConfirmation},
    );
    String body = response.body;
    print(body);
    var data = json.decode(response.body);
    return data['id'] != null;
    ///만약 성공하면 true 돌려주고, 실패하면 실패 메시지 출력하고 false 리턴
  }
}
