import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}
DateTime now = DateTime.now();
String string = DateFormat('dd').format(now);
String string1 = DateFormat('MM').format(now);
int date=int.parse(string);
int month=int.parse(string1);

int dayleft=62;
int start=25;



class MyAppState extends State<MyApp> {

  int dayleftnow(int d,int m)
  {
    if(m==8)
    {
      return 31-d+30+26;
    }
    else
    if(m==9)
    {
      return 30-d+26;
    }
    else
    if(m==10&&d<=26)
    {
      return 26-d;
    }
    else
    return -1;
  }
  
  

  @override
  Widget build(BuildContext context) {
   
    // TODO: implement build
    return Scaffold(
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

       
        Text(dayleftnow(30, 9).toString())

          ],
        ),
      ),
    );
  }
}
