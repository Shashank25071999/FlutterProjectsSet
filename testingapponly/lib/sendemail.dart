import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Email extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmailState();
  }
}

class EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: () => _launchURL('sahaishashank2507@gmail.com',
              'Flutter Email Test', 'Hello Shashank'),
          child: new Text('Send mail'),
        ),
      ),
    );
  }
}

_launchURL(String toMailId, String subject, String body) async {
  var url = 'mailto:$toMailId?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
