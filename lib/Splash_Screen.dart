import 'dart:async';

import 'package:flutter/material.dart';

import 'home_Screen.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>HomeScreen()
          )
      );
    });
  }
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var hight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image(image: AssetImage("assets/Frame 4.png",
            ),
              width: width/2,
              height:hight/3 ,
            ),
          )
        ],
      ),
    );
  }
}
