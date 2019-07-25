import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kaistal/contentsview.dart';
import 'package:kaistal/friends.dart';
import 'package:kaistal/splash.dart';
import 'package:kaistal/dialog.dart';

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<Main>{
  int _selectedTab = 0;
  List<String> quicklink = [
    "https://portal.kaist.ac.kr",
    "https://ara.kaist.ac.kr",
    "https://ko-kr.facebook.com/KaDaejeon/",
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

  String _name = "";
  String _email = "";
  String _phone = "";
  String _profilePath = "https://wingsrecoveryohio.org/wp-content/uploads/2013/06/default.png";

  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> sf = SharedPreferences.getInstance();
    sf.then((sf) {
      setState(() {
        this._name = sf.getString("name");
        this._email = sf.getString("email");
        this._phone = sf.getString("phone");
        this._profilePath = sf.getString("profilePath") ?? "https://wingsrecoveryohio.org/wp-content/uploads/2013/06/default.png";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
          )),
      home: Scaffold(
        body: buildPageView(),
        drawer: new Drawer(
            child: Column(children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: Text(this._name),
                  accountEmail: Text(this._email),
                  currentAccountPicture: new CircleAvatar(
                    backgroundImage:
                        new NetworkImage(_profilePath), //
                  ),
                ),
                SizedBox(
                  height: 300.0,
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
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(children: <Widget>[
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('로그아웃'),
                        onTap: () {
                          showAlertDialog(context, () {
                            print("logout cancel");
                            Navigator.pop(context);
                          }, () {
                            SharedPreferences.getInstance().then((sf) {
                              sf.clear();
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashApp(),
                              ),
                            );
                          }, "로그아웃", "로그아웃 하시겠습니까?");
                        })
                  ])))),
        ])),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            bottomTapped(index);
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
          selectedItemColor: Colors.amber[800],
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

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        ContentsView(),
        Friends(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedTab = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
