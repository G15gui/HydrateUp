import 'package:flutter/material.dart';
import 'dart:async';

const themeColor = Color.fromARGB(255, 79, 230, 213);

class LogoPage extends StatefulWidget {
  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });

      Timer(Duration(seconds: 1), () {
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            opacity = 0.0;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydrate Up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        useMaterial3: true,
      ),
      home: Logo(context),
    );
  }

  Widget Logo(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 3),
          child: Text(
            "Hydrate Up",
            style: TextStyle(fontSize: 30, color: themeColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
