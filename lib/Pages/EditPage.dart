import 'dart:convert';
import '../generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

// import 'package:quill_delta/quill_delta.dart';
// import 'package:quill_format/quill_format.dart';
import 'package:flutter/material.dart';

// import 'package:zefyrka/zefyrka.dart';
// import 'package:zefyr/zefyr.dart';
import 'package:notus_format/convert.dart';

// import 'package:notus/convert.dart';
import 'package:dio/dio.dart';
import '../Resources/Constant.dart';
import './SettingDetailPage.dart';

class EditPage extends StatefulWidget {
  EditPage({this.text = ''}) : super();
  final String text;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _controller;

  // ZefyrController _controller;
  // NotusDocument document;
  FocusNode _focusNode;

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

  Future<bool> _sendCommentXmlrpc() async {
    String mk = _controller.text;
    // String mk = notusMarkdown.encode(_controller.document.toDelta());
    mk = mk + '\n\n' + Constant.watermark;
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
      var response = await xml_rpc.call(url, 'wp.newComment', [
        1,
        username,
        password,
        int.parse(cid),
        {
          'content': mk,
        }
      ], headers: {
        "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
      });
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> _sendComment() async {
    return _sendCommentXmlrpc();
  }

  Future<bool> _saveDraft() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('draft', _controller.text);
    // prefs.setString('draft', jsonEncode(_controller.document.toJson()));
    // if (_controller.document.toPlainText() == '\n') return true;
    Fluttertoast.showToast(
        msg: "草稿已保存",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
//        backgroundColor: Theme.of(context).primaryColor,
//        textColor: Colors.white,
        fontSize: 16.0);
    return true;
  }

  Future<bool> _buildDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String draft = '';
    if (widget.text != '') {
      //   final Delta delta = Delta()..insert(widget.text);
      //   document = NotusDocument.fromDelta(delta);
      draft = widget.text;
    } else if (draft != null) {
      draft = prefs.getString('draft');
      //   document = new NotusDocument.fromJson(json.decode(draft) as List);
    }
    // else
    //   document = NotusDocument();
    // _controller = new ZefyrController(document);
    _controller = new TextEditingController(text: draft);
    _focusNode = new FocusNode();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            title: Text(S
                .of(context)
                .edit_title),
            elevation: 0,
            actions: [
              IconButton(icon: Icon(Icons.save), onPressed: _saveDraft),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    bool rst = await _sendComment();
                    if (rst) {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.remove('draft');
                      Fluttertoast.showToast(
                          msg: "发送成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(
                          msg: "发送失败",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    //TODO: send unsuccessfully
                  }),
            ]),
        body: new WillPopScope(
            onWillPop: _saveDraft,
            child:
            // TextField(
            //   controller: _controller,
            //   focusNode: _focusNode,
            // ),
            FutureBuilder(
                future: _buildDocument(),
                builder: (context, AsyncSnapshot<bool> draft) {
                  if (draft.hasData) {
                    return TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 99999
                    );
                  } else
                    return Container();
                })
          // ZefyrEditor(
          //   controller: _controller,
          //   focusNode: _focusNode,
          //     // child: FutureBuilder(
          //     //     future: _buildDocument(),
          //     //     builder: (context, AsyncSnapshot<bool> draft) {
          //     //       if (draft.hasData) {
          //     //         return ZefyrEditor(
          //     //           controller: _controller,
          //     //           focusNode: _focusNode,
          //     //         );
          //     //       } else
          //     //         return Container();
          //     //     })
          // )
        ));
  }
}
