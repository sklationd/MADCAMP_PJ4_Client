import 'package:flutter/material.dart';

import 'package:kaistal/getcontent.dart';
import 'package:kaistal/contentview.dart';

class ContentsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
      ),
      home: StudentNotice(),
    );
  }
}

class StudentNotice extends StatefulWidget {
  @override
  StudentNoticeState createState() => new StudentNoticeState();
}

class StudentNoticeState extends State<StudentNotice> with AutomaticKeepAliveClientMixin {
  GetContent gc = new GetContent();
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  Set<Post> _saved = Set<Post>();
  List<Post> _loaded = List<Post>();

  /// keep alive at page transition
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    gc.getBookmark().then((set) {
      setState(() {
        _saved = set;
      });
    });

    gc.getData().then((posts) {
      setState(() {
        _loaded = posts;
      });
    });
  }

  StudentNoticeState() {
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        gc.getData().then((posts) {
          setState(() {
            _loaded = posts;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("학생 공지사항"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.bookmark_border), onPressed: _pushSaved),
        ],
      ),
      body: _listBuilder(),
    );
//    return new Scaffold(
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
//            expandedHeight: 150.0,
//            pinned: false,
//            floating: true,
//            title: Text('학사 공지사항'),
//            actions: <Widget>[
//              IconButton(
//                  icon: Icon(Icons.bookmark_border), onPressed: _pushSaved),
//            ],
//          ),
//
//        ],
//      ),
//    );
  }

  Widget _listBuilder() {
    if (_loaded.length != 0) {
      return ListView.builder(
        itemCount: _loaded.length,
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          Post post = _loaded[index];
          final bool alreadySaved = _findPost(post);
          return new Column(children: <Widget>[
            ListTile(
              title: Text(_loaded[index].getSubject()),
              trailing: IconButton(
                  icon: Icon(alreadySaved
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                  color: alreadySaved ? Colors.orangeAccent : null,
                  onPressed: () {
                    setState(() {
                      if (alreadySaved) {
                        setState(() {
                          _saved.remove(_findActualPost(post));
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
          ],
        ),
      );
    }
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

  Post _findActualPost(Post post) {
    var it = _saved.iterator;
    while (it.moveNext()) {
      if (it.current.getNttno() == post.getNttno()){
        return it.current;
      }
    }
    return null;
  }

  void _deletePost(Post post) {
    var it = _saved.iterator;
    while (it.moveNext()) {
      if (it.current.getNttno() == post.getNttno()){
        _saved.remove(it.current);
      }
    }
  }
}
