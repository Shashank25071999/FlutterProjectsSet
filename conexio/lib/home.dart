import 'package:conexio/contact.dart';
import 'package:conexio/insertsocietydetails.dart';
import 'package:conexio/listinfo.dart';
import 'package:conexio/login.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  String memberid;
  Home(this.memberid);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState(memberid);
  }
}

class HomeState extends State<Home> {
  var isloading = true;
  HomeState(this.memberid);
  String memberid;
  List<dynamic> responsedata;
  logout()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.remove('password');
    pref.remove('mobile_no');
    pref.remove('name');
    pref.remove('area');
    pref.remove('status');
    pref.remove('member_id');

  }

  Future<void> getdata() async {
    Map<String, dynamic> credentials = {
      "token": "conexo",
      "member_id": memberid
    };
    http.post(
        "http://conexo.in/main/conexo-marketing/public/index.php/api/customer/fetchsociety",
        body: json.encode(credentials),
        headers: {
          "Content-Type": "application/json"
        }).then((http.Response response) {
      responsedata = json.decode(response.body);
      var societyname = responsedata[0]["society_name"];
      var data = responsedata[0];
      setState(() {
        isloading = false;
      });
      print(data);
      print(responsedata.length);
      print(societyname);
      print(responsedata);
    });
    print("shashank");
  }

  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isloading == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
          floatingActionButton: FloatingActionButton(child:Icon(Icons.add) ,onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>InsertSocietyDetails(memberid)));
              
          },),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Shashank",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "9984508400",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Mahagun Puram Location",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(116, 49, 155, 20),
                      // image: DecorationImage(
                      //   image: AssetImage('assets/images/menu_bg.png'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text("All Socities"),
                    trailing: Icon(Icons.home),
                  ),
                  Divider(),
                  ListTile(onTap: (){
                    logout();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  },
                    title: Text("LogOut"),
                    trailing: Icon(Icons.exit_to_app),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(116, 49, 155, 20),
              title: Text("Home"),
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
                          var data = responsedata[index];
                          print(data);
                          print(index);
                          //print(responsedata[index]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListInfo(responsedata[index])));
                        },
                        leading: Icon(
                          Icons.home,
                          color: Color.fromRGBO(116, 49, 155, 20),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactDetail(
                                        responsedata[index]["society_id"])));
                          },
                          child: Icon(
                            Icons.contacts,
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
                                    "Society Name: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(responsedata[index]["society_name"]),
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
                                    "Status: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text("data")
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
                                    "Last FollowUp: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(" data")
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
                                    "UpComing FollowUp: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(" data")
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
                                    "Remark: ",
                                    style: TextStyle(),
                                  ),
                                ),
                                Text(
                                  "data",
                                )
                              ],
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
