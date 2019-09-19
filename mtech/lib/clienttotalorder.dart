import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtech/auth.dart';
import 'package:mtech/main.dart';
import 'package:mtech/client.dart';

class ClientTotalOrder extends StatefulWidget {
  int clientindex;
  User authenticateuser;
  List<Clientinfo> totalclients;
  List<Clientordersid> clienttotalorderid;
  List<Clientmid> machineId;
  ClientTotalOrder(this.totalclients, this.authenticateuser, this.machineId,
      this.clienttotalorderid, this.clientindex);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClientTotalOrderState(totalclients, authenticateuser, machineId,
        clienttotalorderid, clientindex);
  }
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();

class ClientTotalOrderState extends State<ClientTotalOrder> {
  String status;
  int clientindex;
  User authenticateuser;
  List<Clientordersid> clienttotalorderid;
  List<Clientmid> machineId;
  List<Clientinfo> totalclients;
  ClientTotalOrderState(this.totalclients, this.authenticateuser,
      this.machineId, this.clienttotalorderid, this.clientindex);

  void updatestatus(int orderindex, String updatestatus) async {
    Map<String, dynamic> updatemap = {'status': updatestatus};
    Map<String,dynamic>responce;
    http.Response responsestatus = await http.patch(
        'https://macrotech-44e5c.firebaseio.com/Users/${totalclients[clientindex].dbuserid}/current_order/${clienttotalorderid[orderindex].dbid}.json?auth=${authenticateuser.idToken}',
        body: json.encode(updatemap));
        responce=json.decode(responsestatus.body);
        print(responsestatus.body);
        if(responce.containsKey("status")){ 
          setState(() {
            clienttotalorderid[orderindex].status=updatestatus;
          });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Order Updated"),
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
        else {
      
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Something Went Wrong, Login Again"),
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
  }

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
                          Text(clienttotalorderid[index].oid)
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "MachineId : ",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text(machineId[index].mmid)
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
                          Text(clienttotalorderid[index].status)
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Update Status",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter Status ',
                                labelText: 'Current Status',
                              ),
                              onChanged: (String value) {
                                if (value == null) {}
                                status = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                print(status);
                                updatestatus(index, status);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )));
          },
          itemCount: machineId.length,
        ));
  }
}
