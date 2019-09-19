import 'package:flutter/material.dart';

class ProductsList extends StatelessWidget {
  final List products;
  ProductsList(this.products){
    
  }

  Widget showproduct(BuildContext context, int index) {
    print(products[index]);
    return Card(
      child: Column(children: <Widget>[
        Text(products[index].title),
        Text(products[index].description),
        Text(products[index].price.toString()),
        Text(products[index].id)
      ],)
        
      );
    
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("List Of Item"),
        ),
        body: ListView.builder(
          itemBuilder: showproduct,
          itemCount: products.length,
        ));
  }
}
