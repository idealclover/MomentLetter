import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/convert.dart';
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

  @override
  void initState() {
    super.initState();
    // Create an empty document or load existing if you have one.
    // Here we create an empty document:
    final document = new NotusDocument();
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  Future<Map> _get(List<String> strList) async {
    Map rst = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String str in strList) {
      rst[str] = prefs.getString(str);
    }
    return rst;
  }

  _sendComment() {
    String mk = notusMarkdown.encode(_controller.document.toDelta());
    String url, cid, username, password;
    List<String> strList = ['url', 'cid', 'username', 'password'];
    Future<Map> rst = _get(strList);
    rst.then((Map rstList) {
      if (rstList[strList[0]] == null ||
          rstList[strList[1]] == null ||
          rstList[strList[2]] == null ||
          rstList[strList[3]] == null) {
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
      } else
        url = rstList[strList[0]] + '/action/xmlrpc';
      cid = rstList[strList[1]];
      username = rstList[strList[2]];
      password = rstList[strList[3]];
      xml_rpc.call(url, 'wp.newComment', [
        1,
        username,
        password,
        int.parse(cid),
        {
          'content': mk,
        }
      ]).then((result) {
        Navigator.of(context).pop();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("发送成功")));
      }).catchError((error) => print(error));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            new IconButton(
              // action button
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: _sendComment(),
            ),
          ],
        ),
        body: ZefyrScaffold(
          child: ZefyrEditor(
            controller: _controller,
            focusNode: _focusNode,
          ),
        ));
  }
}
