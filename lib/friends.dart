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

class SearchUsersState extends State<SearchUsers> with AutomaticKeepAliveClientMixin {
  GetUsers gu = new GetUsers();
//  Future<List<User>> _futureData;

  List<User> lu = List<User>();
  /*
  gu.getData().then((userlist) {
    setState(() {
    lu = userlist
    }
    )})
   */

  List<User> _dataForDisplay;

  TextEditingController editingController = new TextEditingController();
//  String filter;

  @override
  void initState() {
    super.initState();
    _futureData = gu.getData();
//    controller.addListener(() {
//      setState(() {
//        filter = controller.text;
//      });
//    });
//    _dataForDisplay = gu.getData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var futureBuilderData = FutureBuilder(
      future: _futureData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List<User> loaded = snapshot.data;
//          List<User> loadedForDisplay = snapshot.data;

//          _listUser(index) {
          return Container(
//            child: Padding(
//              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {

                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0))
                        )
                      )
                    )
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: loaded.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            loaded[index].getFirstname() +" "+ loaded[index].getLastname(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        );
                      },
                    ),
                  ),

//                    Text(
//                      loaded[index].getFirstname() +" "+ loaded[index].getLastname(),
//                      style: TextStyle(
//                          fontSize: 22,
//                          fontWeight: FontWeight.bold
//                      ),
//                    ),
//                    Text(
//                      loaded[index].getUsername(),
//                      style: TextStyle(
//                          color: Colors.grey.shade600
//                      ),
//                    ),

                ],
              ),
//            ),
          );
//          }

//          _searchBar() {
//            return Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TextField(
//                decoration: InputDecoration(
//                  hintText: 'Search users..'
//                ),
//
//                onChanged: (text) {
//                  text = text.toLowerCase();
//                  setState(() {
//                    loaded = loaded.where( (user) {
//                      var userName = user.getFirstname().toLowerCase();
//                      return userName.contains(text);
//                    }).toList();
//                  });
//                },
//
//              )
//            );
//          }

//          return ListView.builder(
////            controller: _controller,
//            itemCount: loaded.length,
//            itemBuilder: (BuildContext context, int index) {
//                return _listUser(index);
////              return index == 0 ? _searchBar() : _listUser(index - 1);
//            },
//          );
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
        title: new Text("멋진 유져들"),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.search), onPressed: () {},)
//        ]
      ),
      body: futureBuilderData,
    );
  }
}

//class DataSearch extends SearchDelegate<String>{
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    // actions for app bar
//    return [
//      IconButton(icon: Icon(Icons.clear), onPressed: () {})];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    // leading icon on the left of the app bar
//    return IconButton(
//        icon: AnimatedIcon(
//          icon: AnimatedIcons.menu_arrow,
//          progress: transitionAnimation,
//        ),
//        onPressed: null);
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    // show some result based on the selection
//    return null;
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // show when someone searches for users
//    final suggestionList = query.isEmpty ?
//  }
//
//}

