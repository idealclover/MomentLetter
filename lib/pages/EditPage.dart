import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/convert.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import './SettingPage.dart';

class EditPage extends StatefulWidget {
  EditPage() : super();
  final String title = 'Edit';

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  ZefyrController _controller;
  FocusNode _focusNode;
  NotusDocument document;

  @override
  void initState() {
    super.initState();

  }

  void _alert() async {
    await _saveDraft();
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
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SettingPage()));
                  },
                )
              ]);
        });
  }

  Future<Map> _get(List<String> strList) async {
    Map rst = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String str in strList) {
      rst[str] = prefs.getString(str);
    }
    return rst;
  }

  Future<bool> _sendCommentXmlrpc() async{
    String mk = notusMarkdown.encode(_controller.document.toDelta());
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
    try{
      var response = await xml_rpc.call(url, 'wp.newComment', [
        1,
        username,
        password,
        int.parse(cid),
        {
          'content': mk,
        }
      ],headers: {
        "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
      });
      return true;
    } catch(error){
      print(error);
      return false;
    }
  }

  Future<bool> _sendCommentRestful() async{
    String url, cid, token, username, email;
    String mk = notusMarkdown.encode(_controller.document.toDelta());
    List<String> strList = ['url', 'cid', 'token', 'username', 'email'];
    Map rst = await _get(strList);
    if (rst[strList[0]] == null ||
        rst[strList[1]] == null ||
        rst[strList[3]] == null ||
        rst[strList[4]] == null) {
        _alert();
        return false;
      }
    url = rst[strList[0]];
    cid = rst[strList[1]];
    token = rst[strList[2]];
    username = rst[strList[3]];
    email = rst[strList[4]];
    Dio dio = new Dio();
    try{
      Response response = await dio.post(url + '/restful/comment',
          data: {
            'cid': int.parse(cid),
            'text': mk,
            'author': username,
            'mail': email,
            'url': url,
            'token': token
          },
          options: Options(headers: {
            "Content-Type":"application/json",
            "User-Agent":
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
          }));
      return true;
    } on DioError catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> _sendComment () async {
    bool _useRestful;
    List<String> strList = ['restful'];
    Map rst = await _get(strList);
    _useRestful = (rst[strList[0]]==null || rst[strList[0]]== "false") ? false : true;
    if(_useRestful) return await _sendCommentRestful();
    else return _sendCommentXmlrpc();
  }

  Future<bool> _saveDraft() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('draft', jsonEncode(_controller.document.toJson()));
    Fluttertoast.showToast(
        msg: "草稿已保存",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.indigo,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return true;
  }

  Future<bool> _buildDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String draft = prefs.getString('draft');
    if (draft != null)
      document = new NotusDocument.fromJson(json.decode(draft) as List);
    else
      document = NotusDocument();
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveDraft();
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(title: Text(widget.title), actions: [
          FlatButton(
              onPressed: () async {
                bool rst = await _saveDraft();
                if (rst) Navigator.of(context).pop();
              },
              child: Text('SAVE', style: TextStyle(color: Colors.white))),
          FlatButton(
              onPressed: () async {
                bool rst = await _sendComment();
                if (rst) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('draft');
                  Fluttertoast.showToast(
                      msg: "发送成功",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.indigo,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(
                      msg: "发送失败",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.indigo,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                //TODO: send unsuccessfully
              },
              child: Text('SEND', style: TextStyle(color: Colors.white)))
        ]
//          <Widget>[
//            new IconButton(
//              // action button
//              icon: Icon(Icons.check, color: Colors.white),
//              onPressed: _sendComment(notusMarkdown.encode(_controller.document.toDelta())),
//            ),
//          ],
            ),
        body: new WillPopScope(
            onWillPop: _saveDraft,
            child: ZefyrScaffold(
              child: FutureBuilder(
                future: _buildDocument(),
                builder: (context, AsyncSnapshot<bool> draft) {
                  if (draft.hasData) {
                    return ZefyrEditor(
                      controller: _controller,
                      focusNode: _focusNode,
                    );
                  } else
                    return Container();
                }))));
//        body: ZefyrScaffold(
//          child: ZefyrEditor(
//            controller: _controller,
//            focusNode: _focusNode,
//          ),
//        ));
  }
}
