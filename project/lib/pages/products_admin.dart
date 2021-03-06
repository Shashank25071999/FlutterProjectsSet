import 'package:flutter/material.dart';
import 'package:project/pages/product_create.dart';
import 'package:project/pages/product_list.dart';


class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text("Choose"),
              ),
              ListTile(
                title: Text("All product"),
                onTap: () {
                  Navigator.pushReplacementNamed(context,'/');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Manage Products"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Create Product",
                icon: Icon(Icons.create),
              ),
              Tab(
                text: 'My product',
                icon: Icon(Icons.list),
              )
            ],
          ),
        ),
        body:TabBarView(children: <Widget>[
          ProductCreatePage(),
          ProductListPage()
        ],),
      ),
    );
  }
}
