import 'package:flutter/material.dart';

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
  }}