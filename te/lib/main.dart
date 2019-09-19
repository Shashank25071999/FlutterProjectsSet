import 'package:flutter/material.dart';
import './product_manager.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber, 
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Food"),
        ),
        body: ProductManager(),
      ),
    );
  }
}
