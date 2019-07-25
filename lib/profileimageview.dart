import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

import 'package:kaistal/main.dart';

class ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter image picker',
      home: ProfileImageView(),
    );
  }
}

class ProfileImageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileImageView();
  }
}

class _ProfileImageView extends State<ProfileImageView> {
  File _image;

  void getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: new Text("프로필 이미지 설정"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check), onPressed: () => _sendImage(_image)),
          ],
        ),
        body: Center(
          child:
              _image == null ? Text('버튼을 눌러 이미지를 추가해주세요') : Image.file(_image),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () => getGalleryImage(),
              tooltip: 'getGalleryImage',
              child: Icon(Icons.photo_library),
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () => getCameraImage(),
              tooltip: 'getCameraImage',
              child: Icon(Icons.photo_camera),
            ),
          ],
        ),
      ),
    );
  }

  _sendImage(File image) async {
    ///send Image
    SharedPreferences sf = await SharedPreferences.getInstance();
    String username = sf.getString("username");
    var uri = Uri.parse("http://52.78.7.28:8080/users/$username/photo");
    int length = await _image.length();
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    final request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('imageFile', stream, length, filename: path.basename(_image.path));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Main(),
      ),
    );
  }
}
