import 'package:flutter/material.dart';

class CommentComponent extends StatelessWidget {
  CommentComponent({this.name, this.text});

  final String name;
  final String text;

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
                    child: new CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://secure.gravatar.com/avatar/a95161b3602abef9f540e7fc6c8cb53a"),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name, style: Theme.of(context).textTheme.subhead),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
