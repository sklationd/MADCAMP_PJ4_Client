import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetContent {
  int start = 1;
  int to = 20;

  List<Post> postlist = List();

  List<Post> getPosts() {
    return postlist;
  }

  Future<List<Post>> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull(
          'http://www.kaist.ac.kr/_module/api/json.php?code=kaist_student&start=' +
              start.toString() +
              '&display=' +
              to.toString()),
    );
    String body = utf8.decode(response.bodyBytes);
    List data = jsonDecode(body);
    for (var json in data) {
      Post post = new Post();
      int ntt_no = int.parse(json['ntt_no']);
      post.setNttno(ntt_no);
      String subject =json['subject'];
      post.setSubject(subject);
      String contents =json['contents'];
      post.setContents(contents);
      postlist.add(post);
    }
    start += to;
    to += to;
    return postlist;
  }

  Future<Set<Post>> getBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String username = prefs.getString("username");
    http.Response response = await http.get(
      Uri.encodeFull('http://52.78.7.28:8080/users/$username/bmrked_posts'),
      headers: {'token':token},
    );
    Set<Post> bookmark = Set();
    String body = utf8.decode(response.bodyBytes);
    List data = jsonDecode(body);
    for (var json in data) {
      Post post = new Post();
      int ntt_no = int.parse(json['ntt_no']);
      post.setNttno(ntt_no);
      String subject =json['subject'];
      post.setSubject(subject);
      String contents =json['contents'];
      post.setContents(contents);
      bookmark.add(post);
    }
    return bookmark;
  }

  void deleteBookmark(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String username = prefs.getString("username");
    int ntt_no = post.getNttno();
    http.delete(
      Uri.encodeFull('http://52.78.7.28:8080/users/$username/$ntt_no'),
      headers: {"token": token},
    );
  }

  void postBookmark(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String username = prefs.getString("username");
    int ntt_no = post.getNttno();

    var postBody = jsonEncode({'ntt_no': ntt_no, 'subject': post.getSubject(), 'contents':post.getContents()});

    http.post(
      Uri.encodeFull('http://52.78.7.28:8080/users/$username/bmrked_posts'),
      headers: {"token": token},
      body : postBody,
    );
  }
}

class Post {
  int _ntt_no;
  String _subject;
  String _contents;

  void setNttno(int nttno) {
    _ntt_no = nttno;
  }

  int getNttno() {
    return _ntt_no;
  }

  void setSubject(String subject) {
    _subject = subject;
  }

  String getSubject() {
    return _subject;
  }

  void setContents(String contents) {
    _contents = contents;
  }

  String getContents() {
    return _contents;
  }
}
