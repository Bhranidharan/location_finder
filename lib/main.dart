import 'package:flutter/material.dart';
import 'package:map_demo/home.dart';
import 'package:map_demo/userLoc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: LiveLocationTracker());
  }
}
