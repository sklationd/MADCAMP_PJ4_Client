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
  Set<Post> _saved = Set<Post>();

  @override
  void initState() {
    super.initState();
    gc.getBookmark().then((set) {
      setState(() {
        _saved = set;
      });
    });
    _futureData = gc.getData();
  }

  StudentNoticeState() {
    _controller.addListener(() {
      print(_controller.offset);
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd)
        setState(() {
          _futureData = gc.getData();
        });
    });
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
              final bool alreadySaved = _findPost(post);
              return new Column(children: <Widget>[
                ListTile(
                  title: Text(loaded[index].getSubject()),
                  trailing: IconButton(
                      icon: Icon(alreadySaved
                          ? Icons.bookmark
                          : Icons.bookmark_border),
                      color: alreadySaved ? Colors.orangeAccent : null,
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            setState(() {
                              _saved.remove(post);
                              gc.deleteBookmark(post);
                            });
                          } else {
                            setState(() {
                              _saved.add(post);
                              gc.postBookmark(post);
                            });
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
          IconButton(icon: Icon(Icons.bookmark_border), onPressed: _pushSaved),
        ],
      ),
      body: futureBuilderData,
    );
  }

  void _pushSaved() {
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

  bool _findPost(Post post) {
    var it = _saved.iterator;
    while (it.moveNext()) {
      if (it.current.getNttno() == post.getNttno()) return true;
    }
    return false;
  }
}
