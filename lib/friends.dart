import 'package:flutter/material.dart';

import 'package:kaistal/getusers.dart';

class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SearchUsers(),
    );
  }
}

class SearchUsers extends StatefulWidget {
  @override
  SearchUsersState createState() => new SearchUsersState();
}

class SearchUsersState extends State<SearchUsers> {
  GetUsers gu = new GetUsers();
//  ScrollController _controller =
//      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  Future<List<User>> _futureData;

  @override
  void initState() {
    _futureData = gu.getData();
    super.initState();
  }

//  SearchUsersState() {
//    _controller.addListener(() {
//      print(_controller.offset);
//      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
//      if (isEnd)
//        setState(() {
//          _futureData = gu.getData();
//        });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    var futureBuilderData = FutureBuilder(
      future: _futureData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<User> loaded = snapshot.data;
          List<User> loadedForDisplay = snapshot.data;

          _listUser(index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      loadedForDisplay[index].getFirstname() +" "+ loaded[index].getLastname(),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      loadedForDisplay[index].getUsername(),
                      style: TextStyle(
                          color: Colors.grey.shade600
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          _searchBar() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search users..'
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(() {
                    loadedForDisplay = loaded.where((user) {
                      var userName = user.getFirstname().toLowerCase();
                      return userName.contains(text);
                    }).toList();
                  });
                },
              )
            );
          }

          return ListView.builder(
//            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              return index == 0 ? _searchBar() : _listUser(index - 1);
            },
            itemCount: loadedForDisplay.length + 1
          );
        } else {
          return Center(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading the coolest people who use this app!!")
              ]
            )
          );
        }
      }
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("멋진 유져들")
      ),
      body: futureBuilderData,
    );
  }
}


