import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import './pages/CrossPage.dart';

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
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
        ).copyWith(
          secondary: Colors.red,
        ),
        // colorScheme: ColorScheme.fromSwatch(
        //     brightness: Brightness.light,
        //     // primarySwatch: Colors.grey,
        //     primarySwatch: MaterialColor(
        //       0xFFFFFFFF,
        //       const <int, Color>{
        //         50: const Color(0xFFFFFFFF),
        //         100: const Color(0xFFFFFFFF),
        //         200: const Color(0xFFFFFFFF),
        //         300: const Color(0xFFFFFFFF),
        //         400: const Color(0xFFFFFFFF),
        //         500: const Color(0xFFFFFFFF),
        //         600: const Color(0xFFFFFFFF),
        //         700: const Color(0xFFFFFFFF),
        //         800: const Color(0xFFFFFFFF),
        //         900: const Color(0xFFFFFFFF),
        //       },
        //     )
        // ).copyWith(
        //   secondary: Colors.red,
        // ),
        // textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        // brightness: Brightness.light,
        // primaryColor: Colors.white,
        // inputDecorationTheme: InputDecorationTheme(
        //   labelStyle: new TextStyle(color: Colors.black),
        //   focusedBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.black)),
        // ),
        // colorScheme: ColorScheme.fromSwatch(
        //   primarySwatch: Colors.blue,
        // ).copyWith(secondary: Colors.red)
      ),
      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSwatch(
      //       brightness: Brightness.dark,
      //       primarySwatch: Colors.grey,
      //   ).copyWith(
      //     secondary: Colors.red,
      //   ),
      //   // primaryColor: Colors.black,
      //   // brightness: Brightness.dark,
      //   // primarySwatch: Colors.grey,
      //   // colorScheme: ColorScheme.fromSwatch(
      //   //   primarySwatch: Colors.blue,
      //   // ).copyWith(secondary: Colors.red),
      // ),
      home: SendCrossPage(),
    );
  }
}
