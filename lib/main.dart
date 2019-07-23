import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:kaistal/contentsview.dart';
import 'package:kaistal/friends.dart';

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<Main> {
  int _selectedTab = 0;
  List<String> quicklink = [
    "https://portal.kaist.ac.kr",
    "https://ara.kaist.ac.kr",
    "https://ko-kr.facebook.com/KaDaejeon/"
        "https://mail.kaist.ac.kr",
    "https://otl.kaist.ac.kr",
    "https://scspace.kaist.ac.kr",
    "https://urs.kaist.ac.kr",
    "https://kds.kaist.ac.kr",
    "https://klms.kaist.ac.kr",
  ];

  List<String> linkname = [
    "포탈",
    "아라",
    "카대전",
    "메일",
    "OTL",
    "공간위",
    "통합예약",
    "기숙사",
    "KLMS"
  ];

  final _pageOptions = [
    ContentsView(),
    Friends(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
          )),
      home: Scaffold(
        body: _pageOptions[_selectedTab],
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text("testusername"),
                accountEmail: Text("test@test.com"),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
                ),
              ),
              SizedBox(
                height: 600.0,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(
                    9,
                    (index) {
                      return Center(
                        child: GestureDetector(
                          child: new Container(
                            height: 80,
                            width: 80,
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                color: Colors.grey,
                                width: 3,
                              ),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.link),
                                Text(linkname[index])
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          onTap: () {
                            _launchURL(quicklink[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notice'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Friends'),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
