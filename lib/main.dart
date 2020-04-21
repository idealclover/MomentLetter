import 'package:flutter/material.dart';
import './pages/SendCrossPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时光信笺',
      theme: ThemeData(
          primaryColor: Color(0xFF919FC5),
          accentColor: Color(0xFFA6B4CA),
          primaryColorBrightness: Brightness.dark),
      home: SendCrossPage(),
    );
  }
}
