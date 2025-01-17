import 'package:flutter/material.dart';

import 'package:kaistal/getcontent.dart';
import 'package:kaistal/contentview.dart';

class ContentsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: StudentNotice(),
    );
  }
}

class StudentNotice extends StatefulWidget {
  @override
  StudentNoticeState createState() => new StudentNoticeState();
}

class StudentNoticeState extends State<StudentNotice> {
  GetContent gc = new GetContent();
  ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  Future<List<Post>> _futureData;
  Future<Set<Post>> _futureBookmark;
  final Set<Post> _saved = Set<Post>();
  StudentNoticeState() {
    _controller.addListener(() {
      print(_controller.offset);
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd)
        setState(() {
          _futureData = gc.getData();
        });
    });
    _futureData = gc.getData();
    //_futureBookmark = gc.getBookmark();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilderData = FutureBuilder(
      future: _futureData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Post> loaded = snapshot.data;

          return ListView.builder(
            itemCount: loaded.length,
            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              Post post = loaded[index];
              final bool alreadySaved = _saved.contains(post);
              return new Column(children: <Widget>[
                ListTile(
                  title: Text(loaded[index].getSubject()),
                  trailing: IconButton(
                      icon: Icon(_saved.contains(post)
                          ? Icons.bookmark
                          : Icons.bookmark_border),
                      color: alreadySaved ? Colors.orangeAccent : null,
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(post);
//                            gc.deleteBookmark(post);
                          } else {
                            _saved.add(post);
//                            gc.postBookmark(post);
                          }
                        });
                      }),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentView(post),
                      ),
                    );
                  },
                ),
                new Divider(
                  height: 2.0,
                ),
              ]);
            },
          );
        } else {
          return Center(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading"),
              ],
            ),
          );
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("학생 공지사항"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: futureBuilderData,
    );
  }

  void _pushSaved() {
    var futureBuilderBookmark = FutureBuilder(
      future: _futureBookmark,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // Load Done
          Set<Post> loaded = snapshot.data;
          return ListView.builder(
            itemCount: loaded.length,
            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              final bool alreadySaved = true;

              final Iterable<ListTile> tiles = loaded.map(
                (Post post) {
                  return ListTile(
                    title: Text(
                      post.getSubject(),
                    ),
                    trailing: Icon(
                      loaded.contains(post)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: alreadySaved ? Colors.orangeAccent : null,
                    ),
                    onTap: () {
                      setState(() {
                        if (alreadySaved) {
                          //loaded.remove(post);
                          gc.deleteBookmark(post);
                        }
                      });
                    },
                  );
                },
              );

              final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return Scaffold(
                appBar: AppBar(
                  title: Text('즐겨찾는 공지사항'),
                ),
                body: ListView(children: divided),
              );
            },
          );
        } else if (snapshot.hasError) {
          // Error
          return new Text("${snapshot.error}");
        }
        return Center(
          // Loading in Progress
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (Post post) {
              return ListTile(
                title: Text(
                  post.getSubject(),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentView(post),
                    ),
                  );
                },
              );
            },
          );

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('즐겨찾는 공지사항'),
            ),
            body: ListView(children: divided),
          );

          ///return futureBuilderBookmark;
        },
      ),
    );
  }
}
