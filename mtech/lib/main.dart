import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:mtech/auth.dart';
import 'package:mtech/clients.dart';
import 'package:mtech/upload.dart';

void main() {
  runApp(MaterialApp(
    home: Auth(),
  ));
}


class MyApp extends StatefulWidget {
  final User authenticateuser;
  Function logout;
  MyApp(this.authenticateuser, this.logout);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState(authenticateuser, logout);
  }
}

class Clientinfo {
  String name,
      email,
      adress,
      id,
      usermachineid,
      usermid,
      orderid,
      dborderId,
      dbuserid;
  int number;
  // List<String>usermid;
}

class Machine {
  String fetchmachineid;
  String machineid;
//  List<String>machineid;
}

class Orders {
  String dborderid;
  String orderid;
}

class MyAppState extends State<MyApp> {
  
GlobalKey<FormState> authkey = GlobalKey<FormState>();
  var processing = false;
  var navigate=true;
  List<Clientinfo> totalclients = [];
  List<Machine> totalmachineid = [];
  List<Orders> totalorderid = [];
  void users() async {
    http
        .get(
            'https://macrotech-44e5c.firebaseio.com/Users.json?auth=${authenticateuser.idToken}')
        .then((http.Response user) {
      final List<Clientinfo> fetchdata = [];
      List<Machine> machineidlist = [];
      List<Orders> orderidlist = [];
      Map<String, dynamic> userdata;
      userdata = jsonDecode(user.body);
      print(userdata);
      if(userdata.containsKey('error')){
        navigate=false;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Auth token expird for security purpose"),
              title: Text("Login Again"),
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
      else{
      userdata.forEach((String clientid, dynamic clientdata) {
        final Clientinfo client = Clientinfo();
        client.name = clientdata['Name'];
        client.dbuserid = clientid;
        client.id = clientdata['id'];
        client.email = clientdata['email'];
        client.adress = clientdata['adress'];
        client.number = clientdata['number'];
        fetchdata.add(client);
        // print(clientdata['Machines']['mid']);r
        // print(clientdata['Machines']);
        Map<String, dynamic> machines = clientdata['Machines'];
        machines.forEach((String id, dynamic mac) {
          Machine machine = Machine();
          print(mac['mid']);
          print(id);
          machine.machineid = mac['mid'];
          machine.fetchmachineid = id;
          machineidlist.add(machine);
          // print(machineidlist);
          //  print(mac['mid']);
        });
        //   print(machineidlist);

        Map<String, dynamic> currentorders = clientdata['current_order'];
        currentorders.forEach((String orderiddb, dynamic order) {
          Orders currentorder = Orders();
          currentorder.orderid = order['order_id'];
          currentorder.dborderid = orderiddb;
          orderidlist.add(currentorder);
        });
      });}

      totalorderid = orderidlist;
      totalclients = fetchdata;
      totalmachineid = machineidlist;
      for (int i = 0; i < totalclients.length; i++) {
        totalclients[i].usermachineid = totalmachineid[i].fetchmachineid;
        totalclients[i].usermid = totalmachineid[i].machineid;
        totalclients[i].orderid = totalorderid[i].orderid;
        totalclients[i].dborderId = totalorderid[i].dborderid;
      }

      //  for(int i=0;i<totalclients.length;i++){
      //    print(totalclients[i].usermid);
      //    print(totalclients[i].usermachineid);
      //    print(totalclients[i].dborderId);
      //    print(totalclients[i].email);
      //    print(totalclients[i].name);
      //    print(totalclients[i].adress);
      //    print(totalclients[i].orderid);
      //    print(totalclients[i].id);
      //    print(totalclients[i].number);
      //  }
      if(navigate==true){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Clients(authenticateuser, totalclients)));}
    });

    // print(totalclients[0].number);
  }

  User authenticateuser;
  Function logout;

  MyAppState(this.authenticateuser, this.logout);
  String name;
  String status;
  String email;
  String address;
  int number;
  String mid;
  String id;
  String order_id;
  Map<String, dynamic> userdata = {
    'Name': '',
    'email': '',
    'adress': '',
    'number': '',
    'random_num': '',
    'id': ''
  };
  Map<String, dynamic> usernotauth = {
    'email': '',
    'random_num': '',
  };
  Map<String, dynamic> orderid = {"order_id": '', "status": ''};
  Map<String, dynamic> machineid = {'mid': ''};

  void _submitform(String name, String email, String adress, int number,
      String orderId, String id, String macid, String status) async {
        setState(() {
         processing=true; 
        });
    int randomNumber = math();

    userdata = {
      'Name': name,
      'email': email,
      'adress': adress,
      'number': number,
      'random_num': randomNumber,
      'id': id
    };
    usernotauth = {
      'email': email,
      'random_num': randomNumber,
    };
    orderid = {'order_id': orderId, 'status': status};
    machineid = {'mid': macid};

    http.Response response = await http.post(
        'https://macrotech-44e5c.firebaseio.com/Users.json?auth=${authenticateuser.idToken}',
        body: json.encode(userdata));
    Map<String, dynamic> responsedata = jsonDecode(response.body);
    String responseid = responsedata['name'];
    http.post('https://macrotech-44e5c.firebaseio.com/Usersnotauth.json',
        body: json.encode(usernotauth));
    http.post(
        'https://macrotech-44e5c.firebaseio.com/Users/${responseid}/current_order.json?auth=${authenticateuser.idToken}',
        body: json.encode(orderid));
    http.post(
        'https://macrotech-44e5c.firebaseio.com/Users/${responseid}/Machines.json?auth=${authenticateuser.idToken}',
        body: json.encode(machineid));

    if (responsedata.containsKey('name')) {
      setState(() {
       processing=false; 
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("UserInfoEntered"),
              title: Text("RandomNumber${randomNumber.toString()}"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    authkey.currentState.reset();
                  },
                )
              ],
            );
          });
    }
    else{
      setState(() {
       processing=false; 
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Your token is expired For Security purpose"),
              title: Text("Login Again"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    authkey.currentState.reset();
                  },
                )
              ],
            );
          });
    }
    print(responsedata);
  }

  int math() {
    var rng = new Random();
    int randomNumber = rng.nextInt(100000);
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("Choose"),
                ),
                ListTile(
                  title: Text(
                    "Upload Pdf",
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FilePickerDemo(authenticateuser)));
                  },
                ),
                ListTile(
                  title: Text("Clients"),
                  onTap: () {
                    users();
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Client Information'),
          ),
          body: Form(
            key: authkey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the name';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter name ',
                          labelText: 'name',
                        ),
                        onSaved: (String value) {
                          name = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the email';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Email ',
                          labelText: 'Email',
                        ),
                        onSaved: (String value) {
                          email = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the address';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter address ',
                          labelText: 'address',
                        ),
                        onSaved: (String value) {
                          address = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the phone';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter phone number ',
                          labelText: 'phone number',
                        ),
                        onSaved: (String value) {
                          if(value.isEmpty){
                            number=null;
                          }
                          else{
                          number = int.parse(value);
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the Id';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'eg:c001 ',
                          labelText: 'Enter Id',
                        ),
                        onSaved: (String value) {
                          id = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the order_id';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'eg:order_001 ',
                          labelText: 'Enter order_id',
                        ),
                        onSaved: (String value) {
                          order_id = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the machine_id';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'eg:m001 ',
                          labelText: 'Enter machine_id',
                        ),
                        onSaved: (String value) {
                          mid = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter the Status';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Status ',
                          labelText: 'Current Status',
                        ),
                        onSaved: (String value) {
                          if(value.isEmpty){
                            status=null;
                          }else{
                          status = value;
                          print(status);
                          }
                        },
                      ),
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
                      RaisedButton(
                        elevation: 50.0,
                        child: Text("Submit Form"),
                        onPressed: () {
                            authkey.currentState.validate();
                          authkey.currentState.save();
                          if(status!=null||number!=null){
                          _submitform(name, email, address, number, order_id,
                              id, mid, status);}
                              else{
                                showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Entered all the column"),
              title: Text("Failed"),
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
                      RaisedButton(
                        child: Text("Logout"),
                        onPressed: () {
                          logout();

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Auth()));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
