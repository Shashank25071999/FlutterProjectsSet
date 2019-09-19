import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Colors.indigo.shade100, end: Colors.blue.shade600)),
      Track("color3").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38375), end: Colors.green.shade900)),
           Track("color4").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38375), end: Colors.indigo.shade900)),
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Scaffold(
          
            body: Container(
          height: 300.0,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.elliptical(100, 100)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [animation["color1"], animation["color2"],animation['color3'],animation['color4']])),
        ));
      },
    );
  }
}
