import 'package:flutter/material.dart';

import '../product_manager.dart';

class ProductsPage extends StatelessWidget {
  final Function addProduct, deleteProduct;
  final List<Map> products;
  ProductsPage(this.products, this.addProduct, this.deleteProduct);
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text("choose"),
              ),
              ListTile(
                title: Text("Manage products"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/admin');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Easy list"),
        ),
        body: ProductManager(products, addProduct, deleteProduct));
  }
}
