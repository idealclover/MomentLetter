import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../pages/CrossPage.dart';
import '../pages/EditPage.dart';
import '../pages/SettingDetailPage.dart';
import '../pages/MusicPage.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  Future<Map> _get(List<String> strList) async {
    Map rst = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String str in strList) {
      rst[str] = prefs.getString(str);
    }
    return rst;
  }

  Future<String> _getAvatar() async {
    return _getEmail().then((String email) {
      var content = new Utf8Encoder().convert(email);
      var digest = md5.convert(content);
      return "https://gravatar.loli.net/avatar/" + hex.encode(digest.bytes);
    });
  }

  Future<String> _getWebSite() async {
    List<String> strList = ['url'];
    return _get(strList).then((Map rstList) {
      if (rstList[strList[0]] == null)
        return "idealclover.top";
      else
        return rstList[strList[0]];
    });
  }

  Future<String> _getEmail() async {
    List<String> strList = ['email'];
    return _get(strList).then((Map rstList) {
      if (rstList[strList[0]] == null)
        return "idealclover@163.com";
      else
        return rstList[strList[0]];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      UserAccountsDrawerHeader(
        currentAccountPicture: new FutureBuilder(
            future: _getAvatar(),
            builder: (context, AsyncSnapshot<String> avatar) {
              if (avatar.hasData && avatar.data != null) {
                return CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(avatar.data),
                    backgroundColor: Theme.of(context).primaryColor);
              } else
                return Text("");
            }),
        accountName: new FutureBuilder(
            future: _getWebSite(),
            builder: (context, AsyncSnapshot<String> website) {
              if (website.hasData && website.data != null) {
                return Text(website.data);
              } else
                return Text("");
            }),
        accountEmail: new FutureBuilder(
            future: _getEmail(),
            builder: (context, AsyncSnapshot<String> email) {
              if (email.hasData && email.data != null) {
                return Text(email.data);
              } else
                return Text("");
            }),
      ),
      ListTile(
          title: Text('时光信笺'),
          trailing: Icon(Icons.send),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => EditPage()));
          }),
      ListTile(
          title: Text('分享歌曲'),
          trailing: Icon(Icons.music_note),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => MusicPage()));
          }),
      ListTile(
          title: Text('检查更新'),
          trailing: Icon(Icons.system_update_alt),
          onTap: () {
//            FlutterBugly.getUpgradeInfo().then((UpgradeInfo info) {
//              if (info != null && info.id != null) {
//                showDialog(
//                    barrierDismissible: false,
//                    context: context,
//                    builder: (BuildContext context) {
//                      return AlertDialog(
//                          title: new Text(info.title),
//                          content: new Text(info.newFeature),
//                          actions: <Widget>[
//                            new FlatButton(
//                              child: new Text("去升级"),
//                              onPressed: () async {
//                                Navigator.of(context).pop();
//                                if (await canLaunch(info.apkUrl)) {
//                                  await launch(info.apkUrl);
//                                } else {
//                                  Scaffold.of(context).showSnackBar(
//                                      SnackBar(content: Text("打开链接失败")));
//                                }
//                              },
//                            ),
//                            new FlatButton(
//                                child: new Text("下次再说"),
//                                onPressed: () => Navigator.of(context).pop())
//                          ]);
//                    });
//              }
//            });
          }),
      ListTile(
          title: Text('投喂作者'),
          trailing: Icon(Icons.free_breakfast),
          onTap: () async {
            Navigator.of(context).pop();
            if (await canLaunch(
                "https://donate.idealclover.cn")) {
              await launch("https://donate.idealclover.cn");
            } else {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("打开链接失败")));
            }
          }),
      ListTile(
          title: Text('作者博客'),
          trailing: Icon(Icons.computer),
          onTap: () async {
            Navigator.of(context).pop();
            if (await canLaunch("https://idealclover.top")) {
              await launch("https://idealclover.top");
            } else {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("打开链接失败")));
            }
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
