import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      
      _counter++;
    });
  }
  void initState(){
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async { 
         print("onMessage: $message");
         
       },
        onResume: (Map<String, dynamic> message) async {
         print("onMessage: $message");
         
       },
        onLaunch: (Map<String, dynamic> message) async {
         print("onMessage: $message");
         
       },
    );
    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true
      )
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotifcationSetting){
        print("reguserter");
    });
    _firebaseMessaging.getToken().then((token){
      update(token);
      print("token:$token");
      
    }); 
  }
  update(String token){
    
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
