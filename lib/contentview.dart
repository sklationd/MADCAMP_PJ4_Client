import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:kaistal/getcontent.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentView extends StatelessWidget {
  Post _post;

  ContentView(Post post){
    _post = post;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: contentPopup(),
    );
  }

  Widget contentPopup() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("자세히보기"),
      ),
      body: new Center(
          child: SingleChildScrollView(
            child: Html(
              data: _post.getContents(),
              onLinkTap: (url) {
                _launchURL(url);
              },
              onImageTap: (src) {
                _launchURL(src);
              }
            ),
          ))
      );
  }

  _launchURL(String url) async {
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
