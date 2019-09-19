import 'package:flutter/material.dart';

import 'package:project/pages/product.dart';

import 'pages/products_admin.dart';
import './pages/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> _products = [];

    void _addproduct(Map product) {
      setState(() {
        _products.add(product);
      });
    }

    void _deleteProduct(int index) {
      setState(() {
        _products.removeAt(index); 
      });
    }

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, accentColor: Colors.deepPurple),
      //home: AuthPage(),
      routes: {
        '/': (context) => ProductsPage(_products, _addproduct, _deleteProduct),
        '/admin': (context) => ProductsAdminPage(),
      },
       onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElement = settings.name.split('/');
        if (pathElement[0] != '') {
          return null;
        }
        if (pathElement[1] == 'product') {
          int index = int.parse(pathElement[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(
                _products[index]['title'], _products[index]['image']),
          );
        }
        return null;
      },
    );
  }
}
