import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './EditPage.dart';

class MusicPage extends StatefulWidget {
  MusicPage() : super();

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  TextEditingController _musicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            title: Text(S.of(context).import_music_title),
            elevation: 0,
            actions: [
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_musicController.text.length <= 0) {
                      return;
                    }
                    const _neteaseExp = r"music\.163\.com";
                    const _neteaseMusicExp1 = r"(?<=\/)[0-9]+(?=\/)";
                    const _neteaseMusicExp2 = r"(?<=\?id\=)[0-9]+(?=\&)";
                    if (RegExp(_neteaseExp).firstMatch(_musicController.text) !=
                        null) {
                      String rst = '';
                      if (RegExp(_neteaseMusicExp1)
                              .firstMatch(_musicController.text) !=
                          null) {
                        rst = RegExp(_neteaseMusicExp1)
                            .firstMatch(_musicController.text)
                            .group(0);
                      } else if (RegExp(_neteaseMusicExp2)
                              .firstMatch(_musicController.text) !=
                          null) {
                        rst = RegExp(_neteaseMusicExp2)
                            .firstMatch(_musicController.text)
                            .group(0);
                      }
                      if (rst == '')
                        await Fluttertoast.showToast(
                            msg: "识别失败",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0);
                      rst = '[Meting]\n[Music server="netease" id="' +
                          rst +
                          '" type="song"/]\n[/Meting]\n';
                      await Fluttertoast.showToast(
                          msg: "识别成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16.0);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditPage(text: rst)));
                    } else {
                      await Fluttertoast.showToast(
                          msg: "识别失败",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16.0);
                    }
                  }),
            ]),
        body: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _musicController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.only(top: 10.0),
                labelText: '歌曲链接',
              ),
            )));
  }
}
