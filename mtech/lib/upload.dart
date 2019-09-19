import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mtech/auth.dart';

GlobalKey<FormState> authKey = GlobalKey<FormState>();

class FilePickerDemo extends StatefulWidget {
  User authenticate;
  FilePickerDemo(this.authenticate);
  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState(authenticate);
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  User authenticateuser;
  var processing=false;
  _FilePickerDemoState(this.authenticateuser);
  Map<String, dynamic> userdata = {
    'Name': '',
    'Id': '',
    'Type': '',
    'Downloadurl': ''
  };
  String name, id, type, downloadurl;

  Future<bool> upload(String _filename, String _path) async {
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(_filename);
    final StorageUploadTask uploadTask = storageRef.putFile(File(_path));
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    downloadurl = (await downloadUrl.ref.getDownloadURL());

    print('URL Is $downloadurl');
    if (downloadurl != null) {
      return true;
    } else {
      return false;
    }
  }

  void uploadinfo(String _filename, String _path) async {
    setState(() {
     processing=true; 
    });
    authKey.currentState.save();
    authKey.currentState.validate();
    bool test = await upload(_filename, _path);
    print(test);
    if (test == true) {
      userdata = {
        'Name': name,
        'Id': id,
        'Type': type,
        'Downloadurl': downloadurl
      };
      http.Response response = await http.post(
          'https://macrotech-44e5c.firebaseio.com/Machines.json?auth=${authenticateuser.idToken}',
          body: jsonEncode(userdata));
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      print(responsedata);
      if (responsedata.containsKey('name')) {
        setState(() {
         processing=false; 
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Machine info entered"),
                title: Text("Information"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Machine info not entered"),
              title: Text("Information"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

//   void downloadFile(String url)async{
//     String uri = Uri.decodeFull(url);
// final RegExp regex = RegExp('([^?/]*\.(jpg))');
// final String fileName = regex.stringMatch(uri);

// final Directory tempDir = Directory.systemTemp;
// final File file = File('${tempDir.path}/$fileName');

// //actual downloading stuff
//     final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
//     final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
//    // file.open(mode: FileMode.READ);
//   }

  String _fileName;

  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    // code of read or write file in external storage (SD card)
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(
            type: _pickingType, fileExtension: _extension);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('File Picker example app'),
      ),
      body: Form(
          key: authKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'enter name of the pdf';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter name of pdf ',
                  labelText: 'Pdf name',
                ),
                onSaved: (String value) {
                  name = value;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter id';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter Id ',
                  labelText: 'Id',
                ),
                onSaved: (String value) {
                  id = value;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'enter the type';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter type',
                  labelText: 'type',
                ),
                onSaved: (String value) {
                  type = value;
                },
              ),
              new Center(
                  child: new Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: new SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: new DropdownButton(
                            hint: new Text('LOAD PATH FROM'),
                            value: _pickingType,
                            items: <DropdownMenuItem>[
                              new DropdownMenuItem(
                                child: new Text('FROM AUDIO'),
                                value: FileType.AUDIO,
                              ),
                              new DropdownMenuItem(
                                child: new Text('FROM IMAGE'),
                                value: FileType.IMAGE,
                              ),
                              new DropdownMenuItem(
                                child: new Text('FROM VIDEO'),
                                value: FileType.VIDEO,
                              ),
                              new DropdownMenuItem(
                                child: new Text('FROM ANY'),
                                value: FileType.ANY,
                              ),
                            ],
                            onChanged: (value) => setState(() {
                                  _pickingType = value;
                                })),
                      ),

                      new Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                        child: new RaisedButton(
                          onPressed: () => _openFileExplorer(),
                          child: new Text("Open file picker"),
                        ),
                      ),
                      new Builder(
                        builder: (BuildContext context) => _path != null ||
                                _paths != null
                            ? new Container(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                height: 120.0,
                                child: new Scrollbar(
                                    child: new ListView.separated(
                                  itemCount: _paths != null && _paths.isNotEmpty
                                      ? _paths.length
                                      : 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMultiPath =
                                        _paths != null && _paths.isNotEmpty;
                                    final String name = 'File $index: ' +
                                        (isMultiPath
                                            ? _paths.keys.toList()[index]
                                            : _fileName ?? '...');
                                    final path = isMultiPath
                                        ? _paths.values
                                            .toList()[index]
                                            .toString()
                                        : _path;

                                    return new ListTile(
                                      title: new Text(
                                        name,
                                      ),
                                      subtitle: new Text(path),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          new Divider(),
                                )),
                              )
                            : new Container(),
                      ),
                         processing == true
                          ? Container(
                              child: SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    Text("Loading")
                                  ],
                                ),
                                height: 200.0,
                                width: 150.0,
                              ),
                            )
                          : Container(),
                      RaisedButton(
                        child: Text("Upload"),
                        onPressed: () {
                          uploadinfo(_fileName, _path);
                        },
                      ),
                      //  RaisedButton(
                      //   child: Text("Download"),
                      //   onPressed: () {
                      //     downloadFile(url);
                      //   },
                      // )
                    ],
                  ),
                ),
              )),
            ],
          )),
    );
  }
}
