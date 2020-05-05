import '../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;
import 'package:dio/dio.dart';
import '../Components/DrawerComponent.dart';
import '../Components/CommentComponent.dart';
import './SettingPage.dart';
import './EditPage.dart';

class SendCrossPage extends StatefulWidget {
  SendCrossPage() : super();

  @override
  _SendCrossPageState createState() => _SendCrossPageState();
}

class _SendCrossPageState extends State<SendCrossPage> {
  List<CommentComponent> _comments = <CommentComponent>[];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _alert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("配置网站"),
              content: new Text("请先进行网站配置>v<"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("去配置"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SettingPage()));
                  },
                )
              ]);
        });
  }

  Future<bool> _loadDataXmlRPC() async {
    String url, cid, username, password;
    List<String> strList = ['url', 'cid', 'username', 'password'];
    Map rst = await _get(strList);
    if (rst[strList[0]] == null ||
        rst[strList[1]] == null ||
        rst[strList[2]] == null ||
        rst[strList[3]] == null) {
      _alert();
      return false;
    }
    url = rst[strList[0]] + '/action/xmlrpc';
    cid = rst[strList[1]];
    username = rst[strList[2]];
    password = rst[strList[3]];
    try {
      var response = await xml_rpc.call(url, 'wp.getComments', [
        1,
        username,
        password,
        {
          'post_id': int.parse(cid),
          'number': 20,
        }
      ]);
      for (var comment in response) {
        Map map = {
          'author': comment['author'],
          'time': comment['date_created_gmt'],
          'data': comment['content'],
        };
        CommentComponent component =
            new CommentComponent(name: map['author'], text: map['data'], time: map['time']);
        _comments.add(component);
      }
      setState(() {
        _comments = _comments;
      });
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> _loadData() async {
    return await _loadDataXmlRPC();
  }

  Future<Null> _refresh() async {
    _comments.clear();
    bool rst = false;
    try {
      rst = await _loadData();
    } catch (error) {
      print(error);
    }
    if (rst) {
      await Fluttertoast.showToast(
          msg: "刷新成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      await Fluttertoast.showToast(
          msg: "刷新失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return;
  }

  Future<Map> _get(List<String> strList) async {
    Map rst = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String str in strList) {
      rst[str] = prefs.getString(str);
    }
    return rst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).app_name),
        ),
        drawer: Drawer(
          child: DrawerComponent(),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(children: <Widget>[
                Flexible(
                    child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemBuilder: (_, int index) => _comments[index],
                          itemCount: _comments.length,
                        )))
              ]));
        }),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => EditPage())),
          tooltip: 'Increment',
          child: new Icon(Icons.add, color: Colors.white),
        ));
  }
}
