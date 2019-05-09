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

  final String title = 'Moment Machine';

  @override
  _SendCrossPageState createState() => _SendCrossPageState();
}

class _SendCrossPageState extends State<SendCrossPage> {
//  final TextEditingController _textController = new TextEditingController();
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
            new CommentComponent(name: map['author'], text: map['data']);
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

  Future<bool> _loadDataRestful() async {
    String url, cid;
    List<String> strList = ['url', 'cid'];
    Map rst = await _get(strList);
    if (rst[strList[0]] == null || rst[strList[1]] == null) {
      _alert();
      return false;
    }
    url = rst[strList[0]];
    cid = rst[strList[1]];
    Dio dio = new Dio();
    Response response = await dio.get(url + '/restful/comments',
        data: {'cid': cid, 'pageSize': 20},
        options: Options(headers: {
          "User-Agent":
              "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
        }));
    var data = response.data;
    if (data['status'] == 'success') {
      for (var i = 0; i < data['data']['pageSize']; i++) {
        Map map = {
          'author': data['data']['dataSet'][i]['author'],
          'time': data['data']['dataSet'][i]['created'],
          'data': data['data']['dataSet'][i]['text'],
        };
        CommentComponent component =
            new CommentComponent(name: map['author'], text: map['data']);
        _comments.add(component);
      }
      setState(() {
        _comments = _comments;
      });
    }
    try {
      Response responseToken = await dio.get(url + '/restful/post',
          data: {'cid': cid},
          options: Options(headers: {
            "User-Agent":
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
          }));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseToken.data['data']['csrfToken']);
      return true;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _loadData() async {
    bool _useRestful;
    List<String> strList = ['restful'];
    Map rst = await _get(strList);
    _useRestful =
        (rst[strList[0]] == null || rst[strList[0]] == "false") ? false : true;
    if (_useRestful)
      return await _loadDataRestful();
    else
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
          timeInSecForIos: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      await Fluttertoast.showToast(
          msg: "刷新失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.indigo,
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
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: DrawerComponent(),
        ),
        body: Builder(builder: (BuildContext context) {
//          send() async {
//            String url, cid, username, password;
//            List<String> strList = ['url', 'cid', 'username', 'password'];
//            Future<Map> rst = _get(strList);
//            rst.then((Map rstList) {
//              if (rstList[strList[0]] == null || rstList[strList[1]] == null ||
//                  rstList[strList[2]] == null || rstList[strList[3]] == null)
//                return;
//              else
//                url = rstList[strList[0]] + '/action/xmlrpc';
//              cid = rstList[strList[1]];
//              username = rstList[strList[2]];
//              password = rstList[strList[3]];
//              xml_rpc.call(url, 'wp.newComment', [
//                1,
//                username,
//                password,
//                int.parse(cid),
//                {
//                  'content': _textController.value.text.toString(),
//                }
//              ]).then((result) {
//                print(result.toString());
//                _textController.clear();
//                Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text("发送成功")));
//                _refresh();
//              }).catchError((error) => print(error));
//            });
//          }

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
//                Row(children: <Widget>[
//                  Flexible(
//                      child: TextField(
//                        controller: _textController,
//                        decoration: InputDecoration.collapsed(
//                            hintText: "说点什么吧"),
////                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
////                        builder: (BuildContext context) => EditPage())),
//                      )),
//                  Container(
//                      margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                      child: new IconButton(
//                        icon: Icon(Icons.send),
//                        onPressed: () => send(),
//                      ))
//                ])
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
