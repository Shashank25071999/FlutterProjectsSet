import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget{
  final Function addproduct;
  ProductControl(this.addproduct);
  @override
  Widget build(BuildContext context) {
    
    return RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text("Add Product"),
          onPressed: () {
            addproduct({'title':'sweet food','image':'assets/food.jpg'});
            
          },
        );
  }
}