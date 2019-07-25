import 'package:flutter/material.dart';
import 'package:kaistal/getusers.dart';
import 'package:url_launcher/url_launcher.dart';

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

class SearchUsersState extends State<SearchUsers> with AutomaticKeepAliveClientMixin {
  GetUsers gu = new GetUsers();
  List<User> _userList = List<User>();
  List<User> _userListForDisplay = List<User>();

  /// keep alive at page transition
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    gu.getData().then((users) {
      setState(() {
        _userList = users;
        _userListForDisplay = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("멋진 유져들"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: _userListBuilder(),
    );
  }

  Widget _userListBuilder() {
    if (_userList.length != 0) {
      return ListView.builder(
        itemCount: _userListForDisplay.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _searchBar();
          } else {
            return new InkWell(
              onTap: () => _showUser(context, index - 1),
              child: _listUser(index - 1)
            );
          }
//          return index == 0 ? _searchBar() : _listUser(context, index - 1);
        },
      );
    } else {
      return Center(
          child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading all users of this app!")
              ]
          )
      );
    }
  }

  _searchBar() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
              hintText: 'Search users..',
              prefixIcon: Icon(Icons.search),
          ),
          onChanged: (text) {
            text = text.toLowerCase();
            List<User> userList = _userList.where((user) {
              var userName = user.getFirstname().toLowerCase();
              return userName.contains(text);
            }).toList();
            setState(() {
              _userListForDisplay = userList;
            });
          },
        )
    );
  }

  _listUser(index) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _userListForDisplay[index].getFirstname() + " " +
                        _userListForDisplay[index].getLastname(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    _userListForDisplay[index].getUsername(),
                    style: TextStyle(
                        color: Colors.grey.shade600
                    ),
                  ),
                ]
            ),
        )
    );
  }

  void _showUser(context, index) {
    String prePath = "my_uploads";
    String postPath = _userListForDisplay[index].getImagePath().substring(11);
    String path = prePath + "/" + postPath;
    String phone_number = _userListForDisplay[index].getPhonenumber();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 350.0,
            width: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 170.0
                    ),
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.lightBlueAccent
                      ),
                    ),
                    Positioned(
                      top: 40.0,
                      left: 80.0,
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 2.0
                          ),
                          image: DecorationImage(
                            image: NetworkImage('http://52.78.7.28:8080/$path/'),
                            fit: BoxFit.cover
                          )
                        ),
                      )
                    )
                  ]
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text(
                    _userListForDisplay[index].getFirstname() + " " +
                          _userListForDisplay[index].getLastname(),
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    )
                  )
                ),
                SizedBox(height: 4.0),
                FlatButton(
                  child: Center(
                    child: Text(
                        _userListForDisplay[index].getEmail(),
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  onPressed: () {}
                ),
                SizedBox(height: 4.0),
                FlatButton(
                  child: Center(
                    child: Text(
                      phone_number,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12.0
                      )
                    )
                  ),
                  onPressed: () => launch("tel://$phone_number"),
                )
              ]
            )
          )
        );
      }
    );
  }
}