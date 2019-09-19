import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtech/auth.dart';
import 'package:mtech/client.dart';
import 'package:mtech/main.dart';

class Clients extends StatefulWidget {
  User authenticateuser;
  List<Clientinfo> totalclients;
  Clients(this.authenticateuser, this.totalclients);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClientsState(authenticateuser, totalclients);
  }
}

// class Clientinfo{
//   String name,email,adress,id,usermachineid,usermid,orderid,dborderId;
//   int number;
// }
class Machine {
  String fetchmachineid;
  String machineid;
}

class Orders {
  String dborderid;
  String orderid;
}

class ClientsState extends State<Clients> {
  List<Clientinfo> totalclients;
  List<Machine> totalmachineid = [];
  List<Orders> totalorderid = [];
  User authenticateuser;
  ClientsState(this.authenticateuser, this.totalclients);
  @override
  void initState() {
    // TODO: implement initState
    //users();
    super.initState();
  }

//   void users() async {
//     http
//         .get(
//             'https://macrotech-44e5c.firebaseio.com/Users.json?auth=${authenticateuser.idToken}')
//         .then((http.Response user) {
//           final List<Clientinfo>fetchdata=[];
//           List<Machine> machineidlist=[];
//           List<Orders>orderidlist=[];
//            Map<String, dynamic> userdata;
//            userdata = jsonDecode(user.body);
//            print(userdata);
//            userdata.forEach((String clientid,dynamic clientdata){
//              final Clientinfo client=Clientinfo();
//              client.name=clientdata['Name'];
//              client.id=clientdata['id'];
//              client.email=clientdata['email'];
//              client.adress=clientdata['adress'];
//              client.number=clientdata['number'];
//              fetchdata.add(client);
//             // print(clientdata['Machines']['mid']);
//             // print(clientdata['Machines']);
//                           Map<String ,dynamic> machines=clientdata['Machines'];//
//                              machines.forEach((String id,dynamic mac){
//                              Machine machine= Machine();
//                              machine.machineid=mac['mid'];
//                              machine.fetchmachineid=id;
//                              machineidlist.add(machine);
//              //  print(mac['mid']);
//              });

//              Map<String,dynamic>currentorders=clientdata['current_order'];
//              currentorders.forEach((String orderiddb,dynamic order){
//                Orders currentorder= Orders();
//                currentorder.orderid=order['order_id'];
//                currentorder.dborderid=orderiddb;
//                orderidlist.add(currentorder);
//                                                                 });
//            });

//            totalorderid=orderidlist;
//            totalclients=fetchdata;
//            totalmachineid=machineidlist;
//            for(int i=0;i<totalclients.length;i++){
//              totalclients[i].usermachineid=totalmachineid[i].fetchmachineid;
//              totalclients[i].usermid=totalmachineid[i].machineid;
//              totalclients[i].orderid=totalorderid[i].orderid;
//              totalclients[i].dborderId=totalorderid[i].dborderid;
//            }

//           //  for(int i=0;i<totalclients.length;i++){
//           //    print(totalclients[i].usermid);
//           //    print(totalclients[i].usermachineid);
//           //    print(totalclients[i].dborderId);
//           //    print(totalclients[i].email);
//           //    print(totalclients[i].name);
//           //    print(totalclients[i].adress);
//           //    print(totalclients[i].orderid);
//           //    print(totalclients[i].id);
//           //    print(totalclients[i].number);
//           //  }

//     });

//  // print(totalclients[0].number);

//   }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("All Clients"),
        ),
        body: ListView.separated(separatorBuilder: (context,int index){
          return Divider(color: Colors.black,);
        },
          itemBuilder: (context, int index) {
            return ListTile(
              title: Text(
                totalclients[index].name,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Client(totalclients,index, authenticateuser)));
              },
              subtitle: Text(totalclients[index].email),
              leading: CircleAvatar(child: Text(totalclients[index].id),),
            );
          },
          itemCount: totalclients.length,
        ));
  }
}
