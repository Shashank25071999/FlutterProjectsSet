import 'package:flutter/material.dart';
import './products.dart';
import './product_control.dart';

class ProductManager extends StatelessWidget {
  final Function addproduct, deleteProduct;
  final List<Map> products;
  ProductManager(this.products, this.addproduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
  
    return Column(
      children: <Widget>[
        ProductControl(addproduct),
        Expanded(
          child: Products(products, deleteProduct),
        )
      ],
    );
  }
}
