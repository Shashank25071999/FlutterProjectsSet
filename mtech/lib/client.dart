import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtech/clienttotalorder.dart';
import 'package:mtech/main.dart';
import 'package:http/http.dart' as http;
import 'package:mtech/auth.dart';

class Client extends StatefulWidget {
  User authenticateuser;

  final List<Clientinfo> totalclients;
  final int index;
  Client(this.totalclients, this.index, this.authenticateuser);
  @override
  State<StatefulWidget> createState() {
    return ClientState(totalclients, index, authenticateuser);
  }
}
bool circle;
class Clientordersid{
  String oid,dbid,status;
}
class Clientmid{
  String mmid,dbmid;
}

class ClientState extends State<Client> {
  var processing=false;
  String neworderid;
  String newmachineid,status;
  
  User authenticateuser;
  int index;
  Map<String, dynamic> newdata = {
    "mid": "",
  };
  Map<String, dynamic> neworderdata;
  List<Clientinfo> totalclients;
  List<Clientmid>machineId=[];
  List<Clientordersid>clienttotalid=[];
  Widget circular(bool value){
    if(value==true){
      return Center(child: CircularProgressIndicator());
    }
    else return null;
  }
  void gettotalorder() async {
    List<Clientmid>mid=[];
    List<Clientordersid>orderid=[];
  
    http.Response response = await http.get(
        'https://macrotech-44e5c.firebaseio.com/Users/${totalclients[index].dbuserid}/Machines.json?auth=${authenticateuser.idToken}');
  http.Response orderdata=await  http.get(
        'https://macrotech-44e5c.firebaseio.com/Users/${totalclients[index].dbuserid}/current_order.json?auth=${authenticateuser.idToken}');   
        Map<String,dynamic>responsedata=json.decode(response.body);
        Map<String,dynamic> responsedataorder=json.decode(orderdata.body);
        print(responsedata);
        responsedata.forEach((String id,dynamic data){
         Clientmid clmid=Clientmid();
         clmid.dbmid=id;
         clmid.mmid=data['mid'];
         mid.add(clmid);
          print(data['mid']);
        });
        responsedataorder.forEach((String id,dynamic data){
          Clientordersid clorid=Clientordersid();
          clorid.dbid=id;
          clorid.oid=data['order_id'];
          clorid.status=data['status'];
          orderid.add(clorid);

        });
        machineId=mid;
        clienttotalid=orderid;
         Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClientTotalOrder(totalclients, authenticateuser,machineId,clienttotalid,index)));
  }

  void neworder(String newmachineid2, String neworderid2,String status) async {
    setState(() {
     processing=true; 
    });
    circle=true;
    circular(circle);
    newdata = {"mid": newmachineid2};
    neworderdata = {"order_id": neworderid2,
    "status":status};
    print(totalclients[index].dbuserid);
    print(totalclients[index].usermachineid);
    print(newmachineid2);
    Map<String ,dynamic>responsedata;
    http.Response response = await http.post(
        'https://macrotech-44e5c.firebaseio.com/Users/${totalclients[index].dbuserid}/Machines.json?auth=${authenticateuser.idToken}',
        body: jsonEncode(newdata));
    http.post(
        "https://macrotech-44e5c.firebaseio.com/Users/${totalclients[index].dbuserid}/current_order.json?auth=${authenticateuser.idToken}",
        body: json.encode(neworderdata));
    print(response.body);
    responsedata=json.decode(response.body);
    if (responsedata.containsKey('name')) {
      setState(() {
       processing=false; 
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("New Order Entered"),
              title: Text("Success"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                   // authkey.currentState.reset();
                  },
                )
              ],
            );
          });
    }
    else if (responsedata.containsKey('name')) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Something Went Wrong,Login Again"),
              title: Text("Failure"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                   // authkey.currentState.reset();
                  },
                )
              ],
            );
          });
    }
    circle=false;
    circular(circle);
  }

  ClientState(this.totalclients, this.index, this.authenticateuser);
  Widget oneclient(BuildContext context, int index) {
    print(totalclients[index].name);
    return Scaffold(
      appBar: AppBar(
        title: Text(totalclients[index].name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Total order"),
              onTap: () {
                gettotalorder();
               
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Client Details",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    "Details",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(totalclients[index].name)
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(totalclients[index].email)
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Address:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(totalclients[index].adress)
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Number:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(totalclients[index].number.toString())
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "UserId:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(totalclients[index].id)
                  ],
                )),
            // Padding(
            //     padding: EdgeInsets.all(10.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Text("Current Order:  ",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //         Text(totalclients[index].orderid)
            //       ],
            //     )),
            // Padding(
            //     padding: EdgeInsets.all(10.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Text("MachineId:  ",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //         Text(totalclients[index].usermid)
            //       ],
            //     )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Enter New Order ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ],
                )),
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
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "OrderId", hintText: "eg:order_001"),
                  onChanged: (String value) {
                    if(value!=null){
                    neworderid = value;
                    }
                    else{
                      neworderid="entered the value";
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "MachineId", hintText: "eg:m001"),
                  onChanged: (String value) {
                    if(value!=null){
                    newmachineid = value;
                    }
                    else{
                        newmachineid="entered the value";
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Status", hintText: "Current status"),
                  onChanged: (String value) {
                    print(value);
                    if(value!=null){
                    status = value;
                    }
                    else{
                        status="entered the value";
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  if(  neworderid!="entered the value"||newmachineid!="entered the value"||status!="entered the value"){
                  neworder(newmachineid, neworderid,status);
                  }
                  else{
                    showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Please fill all the Column"),
              title: Text("Failure"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                   // authkey.currentState.reset();
                  },
                )
              ],
            );
          });
                  }
                },
              ),
            )
          ],
        )
      ]),
    ));
  }
}
