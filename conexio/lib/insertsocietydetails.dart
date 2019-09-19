import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertSocietyDetails extends StatefulWidget {
  var memberid;

  InsertSocietyDetails(this.memberid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InsertSocietyDetailsState(memberid);
  }
}

GlobalKey<FormState> validatekey = GlobalKey<FormState>();

class InsertSocietyDetailsState extends State<InsertSocietyDetails> {
  var memberid;

  InsertSocietyDetailsState(this.memberid);

  var longitude;
  var altitude;
  var cordinatesfetch = false;
  String societyName;
  String status;
  var numberofflats;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Insert Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Form(
            key: validatekey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "enter the String";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      societyName=value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Society Name",
                      labelText: "Society Name",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(36.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(style: BorderStyle.solid, width: 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "enter the String";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      numberofflats=value.toString();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Number of Flats",
                      labelText: "Number of Flats",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(36.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(style: BorderStyle.solid, width: 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("Fetch Co-ordinates"),
                  onPressed: () {
                    // validatekey.currentState.validate();
                    // validatekey.currentState.save();
                    getLoactionhere();
                  },
                ),
                cordinatesfetch
                    ? Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Altitude:"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(altitude.toString()),
                            ),
                          ],
                        ),
                      )
                    : Container(child: Text("Fetch the Altitude"),),
                cordinatesfetch
                    ? Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Longitude:"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(longitude.toString()),
                            ),
                          ],
                        ),
                      )
                    : Container(child: Text("Fetch the longitude"),),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "enter the String";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      status=value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Status",
                      labelText: "Status",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(36.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(style: BorderStyle.solid, width: 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0),child: RaisedButton(child: Text("Add Society"),onPressed: (){
                  validatekey.currentState.validate();
                  validatekey.currentState.save();
                  addsociety();
                },),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getLoactionhere() async {
    var location = Location();
    try {
      var currentLocation = await location.getLocation();
      altitude = currentLocation.altitude;
      longitude = currentLocation.longitude;
      if(altitude==0.0||longitude==0.0){
        setState(() {
          cordinatesfetch=false;

        });
      }
      if (altitude != null && longitude != null) {
        setState(() {
          cordinatesfetch = true;
        });
      }
    } on PlatformException catch (e) {}
  }

  Future<void> addsociety() {
    Map<String, dynamic> societydata = {
      "token": "conexo",
      "society_name": societyName,
      "member_id": memberid,
      "coordinates": "($altitude,$longitude)",
      "status": status,
      "no_of_flats": numberofflats
    };
    http.post(
        "http://conexo.in/main/conexo-marketing/public/index.php/api/customer/addsociety",
        body: json.encode(societydata),
        headers: {
          "Content-Type": "application/json"
        }).then((http.Response response) {
          print(json.decode(response.body));
    });
  }
}
