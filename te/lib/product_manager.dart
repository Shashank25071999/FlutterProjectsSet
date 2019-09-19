import 'package:flutter/material.dart';
import './products.dart';

class ProductManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //0 0TODO: implement createState
    return ProductManagerState();
  }
}

class ProductManagerState extends State<ProductManager> {
  int count = 0;
  // var ele;
  List products = ['food paradise', 'anshul', 'shashank'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(children: [
      Container(
        child: RaisedButton(
          onPressed: () {
            if (count % 2 == 0) {
              count = count + 1;
              setState(() {
                products.add("Advanced food");
              });
            } else {
              count = count + 1;
              setState(() {
                products.add("Good food");
              });
            }
          },
          child: Text("Press"),
        ),
      ),
      
      Products(products,count),
      // Card(child: Image.asset("assets/food.jpg"),),
      //  Card(child: Image.asset("assets/food.jpg"),)
    ]);
  }
}
