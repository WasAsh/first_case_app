import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.grey,
                Colors.red.shade700,
              ],
            ),
          ),
      height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ColorizeAnimatedTextKit(
                  totalRepeatCount: 9,
                  pause: Duration(milliseconds: 1000),
                  isRepeatingAnimation: true,
                  speed: Duration(seconds: 1),
                  text: [' 218 Rescue App '],
                  textStyle: TextStyle(
                      fontSize: 25, fontFamily: "Horizon"),
                  colors: [
                    Colors.black87,
                    Colors.grey[400],
//                    Colors.red,
//                    Colors.grey[400],
                    Colors.white30,
                  ],
                  textAlign: TextAlign.start,
                  alignment: AlignmentDirectional
                      .topStart // or Alignment.topLeft
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'تطبيق الحالة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
              ),
            ],
          ))),
    );
  }
}
