import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List products;
  Products(this.products, this.count);
  final int count;
  String picture(count) {
    if (count % 2 == 0) {
      return "assets/food1.jpg";
    } else
      return "assets/food.jpg";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products
          .map((elements) => Card(
              child: Column(
                  children: [Image.asset(picture(count)), Text(elements)])))
          .toList(),
    );
  }
}
