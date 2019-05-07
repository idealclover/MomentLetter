import 'package:flutter/material.dart';
//import './pages/HomePage.dart';
import './pages/SendCrossPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MomentMachine',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SendCrossPage(),
    );
  }
}
