import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
 final String title, imageurl;
  ProductPage(this.title, this.imageurl);
  @override
  Widget build(BuildContext context) {
 
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Product Details"),
          ),
          body: Column(children: <Widget>[
            Image.asset("assets/food.jpg"),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text("details product"),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  child: Text("Delete"),
                  onPressed: () => Navigator.pop(context, true),
                ))
          ])),
    );
  }
}
