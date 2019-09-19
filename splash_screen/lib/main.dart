import 'dart:async';
import './route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SplashScreenState());
}


class SplashScreenState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
     Timer(
        Duration(seconds: 5),
        () => print("fhfh"));
    // TODO: implement build
    return MaterialApp(
        home: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.shopping_cart,
                          size: 45,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        "Flipkart",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Any Body Can Shop",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
