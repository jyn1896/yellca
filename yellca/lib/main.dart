import 'package:flutter/material.dart';
import 'package:yellca/splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      //디버그 배너 : false
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}