import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import './pages/SendCrossPage.dart';

void main() => FlutterBugly.postCatchedException(() {
      runApp(MyApp());
    });

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterBugly.init(
        androidAppId: "4afa1af849",
        iOSAppId: "your iOS app id",
        enableNotification: true,
        autoCheckUpgrade: true);

    return MaterialApp(
      title: 'MomentMachine',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SendCrossPage(),
    );
  }
}
