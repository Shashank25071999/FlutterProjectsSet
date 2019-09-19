import 'package:authentiction/pages/productslist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './pages/auth.dart';
void main() {
  runApp(MaterialApp(
    home: Auth(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class Product {
  String title;
  String description;
  double price;
  String id;
}

class MyAppState extends State<MyApp> {
  final List<Product> products = [];
  List<Product> excitedproduct=[];
  void fetchProduct() {
    http
        .get('https://flutter-intro-setup-29a7b.firebaseio.com/project.json')
        .then((http.Response response) {
      Map<String, dynamic> productsList = json.decode(response.body);

      productsList.forEach((String productId, dynamic productdata) {
        Product productitem = Product();
        productitem.title = productdata['title'];
        productitem.description = productdata['description'];
        productitem.price = productdata['price'];
        productitem.id = productId;
        products.add(productitem);
       
                    
      });
      print(products[1].title);
      excitedproduct=products;
       setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsList(excitedproduct)));
  
                    });
      print(products.length);
    });
  }

  void _addProduct(String title, String description, double price) {
    Map<String, dynamic> productdata = {
      'title': title,
      'description': description,
      'price': price
    };
    http
        .post('https://flutter-intro-setup-29a7b.firebaseio.com/project.json',
            body: json.encode(productdata))
        .then((http.Response response) {
      final Map<String, dynamic> responsedate = json.decode(response.body);
      print(responsedate);
    });
  }

  String titlevalue;
  String descriptionvalue;
  double pricevalue;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  onChanged: (String value) {
                    setState(() {
                      titlevalue = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  onChanged: (String value) {
                    setState(() {
                      descriptionvalue = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    setState(() {
                      pricevalue = double.parse(value);
                    });
                  },
                ),
                RaisedButton(
                  child: Text("Add Product"),
                  onPressed: () {
                    setState(() {
                      _addProduct(titlevalue, descriptionvalue, pricevalue);
                    });
                  },
                ),
                RaisedButton(
                  child: Text("Show Data"),
                  onPressed: () {setState(() {
                    fetchProduct(); 
                  });
                   
                                      },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
