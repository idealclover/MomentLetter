import '../generated/l10n.dart';
import 'package:flutter/scheduler.dart';
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
  ScrollController _scrollController = ScrollController();
//  GlobalKey<RefreshIndicatorState> _refreshKey =
//      GlobalKey<RefreshIndicatorState>();
  int pageNum = 0;

  @override
  void initState() {
    super.initState();
    _loadData(pageNum);
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      _refreshKey.currentState?.show();
//    });
    _scrollController.addListener(() {
      double edge = 0;
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        pageNum++;
        _loadData(pageNum);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Future<bool> _loadDataXmlRPC(int pageNum) async {
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
        {'post_id': int.parse(cid), 'number': 20, 'offset': (pageNum + 1) * 20}
      ]);
      for (var comment in response) {
//        print(comment);
        if (comment['user_id'] == '0' || comment['parent'] != '0') continue;
        Map map = {
          'author': comment['author'],
          'time': comment['date_created_gmt'],
          'data': comment['content'],
        };
        CommentComponent component = new CommentComponent(
            name: map['author'], text: map['data'], time: map['time']);
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

  Future<bool> _loadData(int pageNum) async {
    print(pageNum);
    return await _loadDataXmlRPC(pageNum);
  }

  Future<Null> _refresh() async {
    _comments.clear();
    bool rst = false;
    try {
//      setState(() {
      pageNum = 0;
//      });
      rst = await _loadData(pageNum);
    } catch (error) {
      print(error);
    }
    if (rst) {
      await Fluttertoast.showToast(
          msg: "刷新成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
//          backgroundColor: Theme.of(context).primaryColor,
//          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      await Fluttertoast.showToast(
          msg: "刷新失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
//          backgroundColor: Theme.of(context).primaryColor,
//          textColor: Colors.white,
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
          elevation: 0,
        ),
        drawer: Drawer(
          child: DrawerComponent(),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(5),
//              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.black12,
              child: Column(children: <Widget>[
                Flexible(
                    child: RefreshIndicator(
//                        key: _refreshKey,
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemBuilder: (_, int index) => _comments[index],
                          itemCount: _comments.length,
                          controller: _scrollController,
                        )))
              ]));
        }),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => EditPage())),
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ));
  }
}
