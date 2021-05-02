import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    _requestPermission();
  }

  GlobalKey _globalkey = new GlobalKey();
  String pic = 'csk';
  String ourtext = "your name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            RepaintBoundary(
              key: _globalkey,
              child: Stack(
                children: [
                  Center(
                    child: Image.asset('images/$pic.png'),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Text(
                          7.toString(),
                          style: TextStyle(fontSize: 150),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 110),
                          child: Text(
                            ourtext,
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pic = 'csk';
                });
              },
              child: Text(
                "CSK",
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pic = 'rcb';
                });
              },
              child: Text(
                "RCB",
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextField(
              onChanged: (val) {
                setState(() {
                  ourtext = val;
                });
              },
              style: TextStyle(fontSize: 30),
            ),
            TextButton(
              onPressed: () async {
                _saveScreen();
              },
              child: Text(
                "SAVE",
                style: TextStyle(fontSize: 30),
              ),
            )
          ],
        ),
      ),
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData?>);
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
