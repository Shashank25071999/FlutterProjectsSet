import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/authuser.dart';
import 'package:http/http.dart' as http;
void main() => runApp(MaterialApp(home:Auth()));

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {

  String url;
  void upload(String _filename, String _path) async {
    final FirebaseAuth auth= FirebaseAuth.instance;
   
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(_filename);
        FirebaseUser user;
        String useridtoken = await user.getIdToken();
      
    final StorageUploadTask uploadTask = storageRef.putFile(File(_path));
  
  

    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');

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
  File _file;
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
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _file=await FilePicker.getFile(type: _pickingType,fileExtension: _extension );
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
       new Scaffold(
        appBar: new AppBar(
          title: const Text('File Picker example app'),
        ),
        body: new Center(
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
                        new DropdownMenuItem(
                          child: new Text('CUSTOM FORMAT'),
                          value: FileType.CUSTOM,
                        ),
                      ],
                      onChanged: (value) => setState(() {
                            _pickingType = value;
                            if (_pickingType != FileType.CUSTOM) {
                              _controller.text = _extension = '';
                            }
                          })),
                ),
                new ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 100.0),
                  child: _pickingType == FileType.CUSTOM
                      ? new TextFormField(
                          maxLength: 15,
                          autovalidate: true,
                          controller: _controller,
                          decoration:
                              InputDecoration(labelText: 'File extension'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
                            if (reg.hasMatch(value)) {
                              _hasValidMime = false;
                              return 'Invalid format';
                            }
                            _hasValidMime = true; 
                            return null;
                          }, 
                        )
                      : new Container(),
                ),
                new ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200.0),
                  child: new SwitchListTile.adaptive(
                    title: new Text('Pick multiple files',
                        textAlign: TextAlign.right),
                    onChanged: (bool value) =>
                        setState(() => _multiPick = value),
                    value: _multiPick,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: new RaisedButton(
                    onPressed: () => _openFileExplorer(),
                    child: new Text("Open file picker"),
                  ),
                ),
                new Builder(
                  builder: (BuildContext context) =>
                      _path != null || _paths != null
                          ? new Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              height: MediaQuery.of(context).size.height * 0.50,
                              child: new Scrollbar(
                                  child: new ListView.separated(
                                itemCount: _paths != null && _paths.isNotEmpty
                                    ? _paths.length
                                    : 1,
                                itemBuilder: (BuildContext context, int index) {
                                  final bool isMultiPath =
                                      _paths != null && _paths.isNotEmpty;
                                  final String name = 'File $index: ' +
                                      (isMultiPath
                                          ? _paths.keys.toList()[index]
                                          : _fileName ?? '...');
                                  final path = isMultiPath
                                      ? _paths.values.toList()[index].toString()
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
                RaisedButton(
                  child: Text("Upload"),
                  onPressed: () {
                    upload(_fileName, _path);
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
      );
  }
}
