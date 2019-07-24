import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetUsers {
  List<User> userlist = List();

  List<User> getUsers() {
    return userlist;
  }

  Future<List<User>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    http.Response response = await http.get(
      Uri.encodeFull('http://52.78.7.28:8080/users/$username'),
    );
    print(response.body);
    List data = jsonDecode(response.body);
    for (var json in data) {
      User user = new User();
      String username = json['username'];
      user.setUsername(username);
      String firstname = json['firstname'];
      user.setFirstname(firstname);
      String lastname = json['lastname'];
      user.setLastname(lastname);
      String email = json['email'];
      user.setEmail(email);
      String phonenumber = json['phonenumber'];
      user.setPhonenumber(phonenumber);
      userlist.add(user);
    }
    return userlist;
  }
}

class User {
  String _username;
  String _firstname;
  String _lastname;
  String _email;
  String _phonenumber;

  void setUsername(String username) {
    _username = username;
  }
  String getUsername() {
    return _username;
  }

  void setFirstname(String firstname) {
    _firstname = firstname;
  }
  String getFirstname() {
    return _firstname;
  }

  void setLastname(String lastname) {
    _lastname = lastname;
  }
  String getLastname() {
    return _lastname;
  }

  void setEmail(String email) {
    _email = email;
  }
  String getEmail() {
    return _email;
  }

  void setPhonenumber(String phonenumber) {
    _phonenumber = phonenumber;
  }
  String getPhonenumber() {
    return _phonenumber;
  }
}