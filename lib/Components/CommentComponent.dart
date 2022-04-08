import '../generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../Resources/Constant.dart';

class CommentComponent extends StatelessWidget {
  CommentComponent({this.name, this.text, this.time});

  final String name;
  final String text;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Card(
//        color: Colors.black,
        elevation: 0,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
//                    new CircleAvatar(
//                        backgroundImage: NetworkImage(
//                            "https://secure.gravatar.com/avatar/a95161b3602abef9f540e7fc6c8cb53a"),
//                        backgroundColor: Theme.of(context).primaryColor),
//                    Padding(padding: EdgeInsets.all(5),),
//                    Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(name,
//                              style: Theme.of(context).textTheme.subhead),
                Text(DateFormat('MM.dd kk:mm').format(time))
//                        ]),
              ]),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: MarkdownBody(
                    data: text.replaceFirst(Constant.watermark, '')),
              ),
            ])));
  }
}
