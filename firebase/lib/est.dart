import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  String filename;
  String path;
  Map<String, String> paths;
  String extension; //dont know the use
  bool multipick = false;
  bool hasValidMime = false; //dont know the use
  FileType pickingType;
  TextEditingController _controller = TextEditingController();

  void _openFileExplorer() async {
    if (pickingType != FileType.CUSTOM || hasValidMime) {
      try {
        if (multipick) {
          path = null;
          paths = await FilePicker.getMultiFilePath(
              type: pickingType, fileExtension: extension);
        } else {
          paths = null;
          path = await FilePicker.getFilePath(
              type: pickingType, fileExtension: extension);
        }
      } on PlatformException catch (e) {
        print("unsupported erroe" + e.toString());
      }
      if (!mounted) {
        //dont know the use
        return;
      }

      setState(() {
        filename = path != null
            ? path.split('/').last
            : paths != null ? paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("selecting and uploding"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(),),
      ),
    ));
  }
}
