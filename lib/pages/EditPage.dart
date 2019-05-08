import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage() : super();
  final String title = 'Edit';

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
