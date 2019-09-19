import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Ripu(),
  ));
}

class Ripu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RipuState();
  }
}

class RipuState extends State<Ripu> {
  String name;
  String id;
  String email;

  String number;
  String unnum;
  String studentnumber;
  String branch;
  Map<String, dynamic> userdata = {
    "name": "",
    "email": "",
    "_id": "",
    "mobilenumber": "",
    "studentNumber": "",
    "universityNumber": "",
    "branch": ""
  };
  void _submitform(String name,String email,String number,String studentnum,String unum,String branch) async {
    userdata = {
      "name": name,
      "email": email,
      "mobileNumber": number,
      "studentNumber": studentnum,
      "universityNumber": unum,
      "branch": branch,
    };
    http.Response response = await http.post(
        "https://registerbigdata.herokuapp.com/",
        body: json.encode(userdata),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> responsedata = jsonDecode(response.body);
    print(responsedata);
    print(name);
    print(email);
    print(number);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Form Page'),
        ),
        body: ListView(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (String value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'branch',
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (String value) {
                    branch = value;
                  },
                ),
                //  TextField(
                //   decoration: InputDecoration(
                //     hintText: 'Id',
                //   ),
                //   keyboardType: TextInputType.text,
                //   onChanged: (String value) {
                //     id = value;
                //   },
                // ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (String value) {
                    number =value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Student Number',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (String value) {
                    studentnumber = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'University Number',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (String value) {
                    unnum = value;
                  },
                ),
                RaisedButton(
                  child: Text("Submit Form"),
                  onPressed: () {
                    setState(() {
                      _submitform(name,email,number,studentnumber,unnum,branch);
                    });
                  },
                )
              ]))
        ]));
  }
}
