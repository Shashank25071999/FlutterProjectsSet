import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:macrotechlogin/clientUser.dart';
import 'package:macrotechlogin/main.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';

class Pdf extends StatefulWidget {
  User authenticateuser;
  List<MachineItem> machinelist;
  List<Orderitem> orderlist;
  Pdf(this.machinelist, this.orderlist, this.authenticateuser);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PdfState(machinelist, orderlist, authenticateuser);
  }
}

class PdfState extends State<Pdf> {
  bool downloading = false;
  var progresString = "";
  List<MachineItem> machinelist;
  User authenticateuser;
  List<Orderitem> orderlist;
  PdfState(this.machinelist, this.orderlist, this.authenticateuser);

  void downloadPdf(List<Orderitem> order, List<MachineItem> machine, int inx,
      BuildContext context) async {
    String url;
    http
        .get(
            'https://macrotech-44e5c.firebaseio.com/Machines.json?auth=${authenticateuser.idToken}')
        .then((http.Response response) {
      Map<String, dynamic> responsedata = json.decode(response.body);
      if (responsedata['error'] == "Auth token is expired") {
        print('login again');
      }
      responsedata.forEach((String id, dynamic data) async {
        if (data['Id'] == machine[inx].mid) {
          //  print(data['Name']);
          // print(data['Downloadurl']);
          url = data['Downloadurl'];
          //  print(id);
          print(url);
          //                String uri = Uri.decodeFull(url);
          //     final RegExp regex = RegExp('([^?/]*\.(pdf))');
          //     final String fileName = regex.stringMatch(uri);
          //     print(fileName);
          //     final Directory tempDir = Directory.systemTemp;
          //     final File file = File('${tempDir.path}/$fileName');
          //     print(file);
          //     print(tempDir);
          //     final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
          //     final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
          // print(downloadTask);
          // downloadTask.future.whenComplete((){
          //   print("complete");
          // });

          // final int byteNumber = (await downloadTask.future).totalByteCount;
          // print(byteNumber);
          Dio dio = Dio();

          try {
            String uri = Uri.decodeFull(url);
            final RegExp regex = RegExp('([^?/]*\.(pdf))');
            final String fileName = regex.stringMatch(uri);
            var dir = await getExternalStorageDirectory();
            await new Directory(dir.path.toString() + "/Scrolls").create(recursive: true);

            print(dir);
            await dio.download(url, "${dir.path}" + "/Scrolls" +"/${fileName}",
                onReceiveProgress: (rec, total) {
              //   print("rec:${rec}");
              // print("total:${total}");
               // pop(downloading, progresString);
              setState(() {
                downloading = true;
                progresString = ((rec / total) * 100).toStringAsFixed(0) + "%";
              });
            });
            
          } catch (e) {
            print(e);
          }
        }
        setState(() {
           downloading=false;
          progresString = 'completed';
        });
      });
    });
    //print(url);
  }

//  Future<Widget> pop(bool downloading, String progresString) {
//     if (downloading) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               content: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   CircularProgressIndicator(),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text(
//                     "Downloading: ${progresString}",
//                     style: TextStyle(color: Colors.black),
//                   )
//                 ],
//               ),
//               title: Text("Downloading"),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text("Okay"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     // authkey.currentState.reset();
//                   },
//                 )
//               ],
//             );
//           });
//     }
//     //  return RadialSeekBar(
//     //   trackColor: Colors.black,
//     //   trackWidth: 4.0,
//     //   progressColor: Colors.red,
//     //   progressWidth: 8.0,
//     //   progress: double.parse(progresString),
  
      
//     //   onDragUpdate: (double percent) {
//     //     setState(() {
//     //      // progresString=percent;
//     //     });
//     //   },
//     // );
//   }
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Total orders"),
        ),
        body: ListView.separated(
          separatorBuilder: (context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
          itemBuilder: (context, int index) {
            return Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Card(
                    child: Container(
                  margin: EdgeInsets.only(left: 13.0, right: 13.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Order No : ${index + 1}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "OrderId : ",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text("${orderlist[index].orderid}")
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      downloading == true
                          ? Container(
                              height: 120.0,
                              width: 200.0,
                              child: Card(
                                color: Colors.black,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text("Downloading ${progresString}",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                            )
                          :Container(),
                      Row(
                        children: <Widget>[
                          Text(
                            "MachineId : ",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text("${machinelist[index].mid}")
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Status : ",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text("${orderlist[index].status}")
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Download Pdf",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: RaisedButton(
                              child: Text("Download"),
                              onPressed: () {
                                // setState(() {
                                //  downloading=true;
                                //  progresString='Downloading';
                                // });
                                // setState(() {
                                //  downloading=true;
                                // });
                                ///  pop(downloading,progresString);
                                downloadPdf(
                                    orderlist, machinelist, index, context);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )));
          },
          itemCount: orderlist.length,
        ));
    ;
  }
}
