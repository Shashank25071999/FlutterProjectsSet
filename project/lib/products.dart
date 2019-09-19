import 'package:flutter/material.dart';
import 'package:project/pages/product.dart';

class Products extends StatelessWidget {
  final List<Map> products;
  final Function deleteProduct;
  Products(this.products, this.deleteProduct);

  Widget _buildProductItem(BuildContext context, int index) {
    print("buildproductitem ececute");
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Text(products[index]['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("Details"),
                
                onPressed: () => Navigator.push(context,MaterialPageRoute(
            builder: (BuildContext context) => ProductPage(
                products[index]['title'], products[index]['image']),
          ))
                        .then( ( value) {
                      if (value) {
                        print(index);
                        deleteProduct(index);
                      }
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productcards = Center(
      child: Text("no data found"),
    );

    if (products.length > 0) {
      productcards = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }
    return productcards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
