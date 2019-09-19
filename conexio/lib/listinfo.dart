import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListInfo extends StatefulWidget {
  var responsedata;
  ListInfo(this.responsedata);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListInfoState(responsedata);
  }
}

class ListInfoState extends State<ListInfo> {
  void initState(){
    super.initState();
    societydata();
  }
  bool pageloading=true;
  var responsedata2;
  Future<void> societydata() async {
    Map<String, dynamic> credentials = {
      "token": "conexo",
      "society_id": responsedata["society_id"]
    };
    http.post(
        "http://conexo.in/main/conexo-marketing/public/index.php/api/customer/fetchremarks",
        body: json.encode(credentials),
        headers: {
          "Content-Type": "application/json"
        }).then((http.Response response) {
      responsedata2 = json.decode(response.body);
      setState(() {
       pageloading=false; 
      });
      print(responsedata2);
    });
  }

  ListInfoState(this.responsedata);
  var responsedata;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return pageloading?Scaffold(body: Center(
      child: CircularProgressIndicator(),
    ),):Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(116, 49, 155, 20),
          title: Text("Details"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: Text(
                              "Society Name: ",
                              style: TextStyle(),
                            ),
                          ),
                          Text("   ${responsedata["society_name"]}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: Text(
                              "No Of Flats: ",
                              style: TextStyle(),
                            ),
                          ),
                          Text("   ${responsedata["no_of_flats"]}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: Text(
                              "No Of Flats: ",
                              style: TextStyle(),
                            ),
                          ),
                          Text("   ${responsedata["no_of_flats"]}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: Text(
                              "No Of Flats: ",
                              style: TextStyle(),
                            ),
                          ),
                          Text("   ${responsedata["no_of_flats"]}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey),
                            child: Text(
                              "No Of Flats: ",
                              style: TextStyle(),
                            ),
                          ),
                          Text("   ${responsedata["no_of_flats"]}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: responsedata2.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      
                                  ),
                                  child: Text(
                                    "Remark: ",
                                    style: TextStyle(),
                                  ),
                                ),
                            Expanded(child:    Text("dsfhbdsjhgbfvjlhbmnvbs k bhB GJB gb bG SDGKJDGKJSFBGBBADFJGB ABG  KHs"),)
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey),
                                  child: Text(
                                    "Follow Up Date: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(responsedata2[index]["follow_up_date"]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
