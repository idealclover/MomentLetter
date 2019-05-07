import 'package:flutter/material.dart';
//import '../pages/HomePage.dart';
import '../pages/SendCrossPage.dart';
//import '../pages/SendPostPage.dart';
import '../pages/SettingPage.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  Widget build(BuildContext context) {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://secure.gravatar.com/avatar/a95161b3602abef9f540e7fc6c8cb53a"),
        ),
        accountName: new Text(
          "idealclover.top",
        ),
        accountEmail: new Text(
          "idealclover@live.com",
        ),
      ),
      ListTile(
          title: Text('时光鸡'),
          trailing: Icon(Icons.send),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SendCrossPage()));
          }),
      ListTile(
          title: Text('设置'),
          trailing: Icon(Icons.settings),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SettingPage()));
          }),
    ]);
  }
}
