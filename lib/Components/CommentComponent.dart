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
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            //TODO
            child: new CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://secure.gravatar.com/avatar/a95161b3602abef9f540e7fc6c8cb53a"),
                backgroundColor: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(name, style: Theme.of(context).textTheme.subhead),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text(DateFormat('yy.MM.dd kk:mm').format(time))
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: MarkdownBody(
                      data: text.replaceFirst(Constant.watermark, '')),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
