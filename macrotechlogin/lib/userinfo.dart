import 'package:flutter/material.dart';
import 'package:macrotechlogin/clientUser.dart';

class UserInfo extends StatelessWidget {
  Account client = Account();
  UserInfo(this.client);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Card(
          child:Padding(padding: EdgeInsets.all(20.0),child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text("Your Profile",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("Name : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  Text(client.name)],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("Email : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  Text(client.email)],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("Registered Number : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  Text(client.number.toString())],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("Address : ",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  Text(client.adress)],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
