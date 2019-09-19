import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ContactDetail extends StatefulWidget {
  ContactDetail(this.societyid);
  String societyid;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactDetailState(societyid);
  }
}

class ContactDetailState extends State<ContactDetail> {
  void initState() {
    super.initState();
    pageloading = true;
    societycontactdata();
  }

  String societyid;
  var responsedata;
  ContactDetailState(this.societyid);
  bool pageloading = true;
  void call(String number) => launch("tel:$number");

  Future<void> societycontactdata() async {
    Map<String, dynamic> societydata = {
      "token": "conexo",
      "society_id": societyid
    };
    http.post(
        "http://conexo.in/main/conexo-marketing/public/index.php/api/customer/fetchcontact",
        body: json.encode(societydata),
        headers: {
          "Content-Type": "application/json"
        }).then((http.Response response) {
      responsedata = json.decode(response.body);
      setState(() {
        pageloading = false;
      });
      print(responsedata);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return pageloading
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text("Contact Details"),
              backgroundColor: Color.fromRGBO(116, 49, 155, 20),
            ),
            body: ListView.separated(
              separatorBuilder: (context, int index) {
                return Divider(
                  color: Colors.black,
                );
              },
              itemCount: responsedata.length,
              itemBuilder: (context, int index) {
                return Card(
                    child: ListTile(
                        onTap: () {
                          print("ullu");
                          // var data=responsedata[index];
                          // print(data);
                          print(index);
                          //print(responsedata[index]);
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => ListInfo(responsedata[index])));
                        },
                        leading: Icon(
                          Icons.home,
                          color: Color.fromRGBO(116, 49, 155, 20),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            call(responsedata[index]['mobile_no']);
                          },
                          child: Icon(
                            Icons.call,
                            color: Color.fromRGBO(116, 49, 155, 20),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey),
                                  child: Text(
                                    "Name: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(responsedata[index]["name"]),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.yellow),
                                  child: Text(
                                    "Mobile No: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(responsedata[index]["mobile_no"])
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey),
                                  child: Text(
                                    "Position ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(responsedata[index]["position"])
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        )));
              },
            ));
  }
}
