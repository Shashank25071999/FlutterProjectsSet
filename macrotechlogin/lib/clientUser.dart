import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:macrotechlogin/main.dart';
import 'package:http/http.dart' as http;
import 'package:macrotechlogin/pdf.dart';
import 'package:macrotechlogin/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ClientUser extends StatefulWidget {
  ClientUser(this.authenticateuser, this.logout);
  Function logout;
  User authenticateuser;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClientUserState(authenticateuser, logout);
  }
}

class Account {
  String email, name, id, adress, userdbid;
  Map<String, dynamic> machines, currentorder;
  int number;
  List machinelist = [];
  List orderlist = [];
}

class Orderitem {
  String status, orderid, dborderid;
}

class MachineItem {
  String mid, dbmid;
}

class ClientUserState extends State<ClientUser> {
  User authenticateuser;
  List<MachineItem> machinelist = [];
  List<Orderitem> orderlist = [];
  Function logout;
  Account client = Account();
  void initState() {
    loginwithclient();
    super.initState();
  }

  Future<bool> loginwithclient() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('name') == null) {
      bool res=await getclient();
      if(res==true){
      return true;
      }
    } else {
      client.name = preferences.getString('name');
      client.email = preferences.getString('email');
      client.adress = preferences.getString('adress');
      client.id = preferences.getString('id');
      client.userdbid = preferences.getString('userdbid');
      client.number = preferences.getInt('number');
      print(client.email);
      print(client.name);
      print(client.currentorder);
      print(client.userdbid);
      print(client.id);
      print(client.machines);
      print(client.number);
      return true;
    }
  }

 Future<bool> getclient() async {
    // print(authenticateuser.idToken);
    http.Response response = await http.get(
        'https://macrotech-44e5c.firebaseio.com/Users.json?auth=${authenticateuser.idToken}');
    Map<String, dynamic> responsebody = json.decode(response.body);

    responsebody.forEach((String id, dynamic data) async {
      //print(data['email']);
      if (authenticateuser.email == data['email']) {
        client.email = data['email'];
        client.name = data['Name'];
        client.currentorder = data['current_order'];
        client.adress = data['adress'];
        client.userdbid = id;
        client.id = data['id'];
        client.number = data['number'];
        client.machines = data['Machines'];
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('name', client.name);
        pref.setString('email', client.email);
        pref.setString('adress', client.adress);
        pref.setString('id', client.id);
        pref.setString('userdbid', client.userdbid);
        // pref.setString('machines', client.machines.toString());
        // pref.setString('currentorder', client.currentorder.toString());
        pref.setInt('number', client.number);
    
      }
    });

    print(client.email);
    print(client.name);
    print(client.currentorder);
    print(client.userdbid);
    print(client.id);
    print(client.machines);
    print(client.number);
    // print(responsebody);
    return true;
  }

  void getorderandmachines() async {
    http
        .get(
            'https://macrotech-44e5c.firebaseio.com/Users/${client.userdbid}.json?auth=${authenticateuser.idToken}')
        .then((http.Response machineandorder) {
      Map<String, dynamic> data = json.decode(machineandorder.body);
      List<MachineItem> tempmachinelist = [];
      List<Orderitem> temporderlist = [];
      print(data);
      client.machines = data['Machines'];
      print(client.machines);
      client.currentorder = data['current_order'];
      print(client.currentorder);
      print(client.name);
      client.machines.forEach((String mdbid, dynamic value) {
        MachineItem machine = MachineItem();
        machine.dbmid = mdbid;
        machine.mid = value['mid'];
        tempmachinelist.add(machine);
      });
      client.currentorder.forEach((String odbid, dynamic value) {
        Orderitem order = Orderitem();
        order.dborderid = odbid;
        order.orderid = value['order_id'];
        order.status = value['status'];
        temporderlist.add(order);
      });

      orderlist = temporderlist;
      machinelist = tempmachinelist;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Pdf(machinelist, orderlist, authenticateuser)));
    });
    // print(machineandorder.body);
  }

  ClientUserState(this.authenticateuser, this.logout);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  AppBar(
                    title: Text("Choose"),
                    automaticallyImplyLeading: false,
                  ),
                   ListTile(
                    title: Text("Your Profile"),
                    trailing: Icon(Icons.info_outline),
                    onTap: ()async {

                     bool result= await loginwithclient();
                     if(result==true){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInfo(client)));
                    }},
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text("Your orders"),
                    trailing: Icon(Icons.list),
                    onTap: () {
                      getorderandmachines();
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text("LogOut"),
                    trailing: Icon(Icons.exit_to_app),
                    onTap: () {
                      logout();

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  )
                ],
              ),
            ),
            appBar: AppBar(
              title: Text("Micromatic"),
            ),
            body: Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text("Welcome",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),)],
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text("To",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0))],
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text("Micromatic",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0))],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
