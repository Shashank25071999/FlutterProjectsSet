import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main() async {
  final int helloAlarmID = 0;
  
  await AndroidAlarmManager.periodic(const Duration(seconds: 10), helloAlarmID, printHello);
   runApp(MaterialApp(home: Scaffold(body:Center(child: Text("data"),)),));
  
}