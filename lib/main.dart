import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 10),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/macos-big-sur-apple-layers-fluidic-colorful-wwdc-stock-4096x2304-1455.jpg'),
                  fit: BoxFit.cover)),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15.0,
            sigmaY: 15.0,
          ),
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(24),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: GoogleFonts.cookie(
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    color: Colors.white),
                child: AnimatedTextKit(
                  pause: Duration(seconds: 1),
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      'hello',
                      speed: const Duration(milliseconds: 500),
                    ),
                    TyperAnimatedText('ola',
                        speed: const Duration(milliseconds: 500)),
                    TyperAnimatedText('ciao',
                        speed: const Duration(milliseconds: 500)),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              )),
        ),
      ],
    );
  }
}
