import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import './pages/SendCrossPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => S.of(context).app_name,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      theme: ThemeData(
          primaryColor: Color(0xFF919FC5),
          accentColor: Color(0xFFA6B4CA),
          primaryColorBrightness: Brightness.dark),
      home: SendCrossPage(),
    );
  }
}
