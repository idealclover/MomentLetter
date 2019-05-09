import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage() : super();
  final String title = 'Settings';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController _urlController;
  TextEditingController _cidController;
  TextEditingController _emailController;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  final FocusNode cidTextFieldNode = FocusNode();
  final FocusNode emailTextFieldNode = FocusNode();
  final FocusNode usernameTextFieldNode = FocusNode();
  final FocusNode passwordTextFieldNode = FocusNode();
  bool _validateUrl = false;
  bool _validateCid = false;
  bool _validateEmail = false;
  bool _validateUsername = false;
  bool _validatePassword = false;
  bool _useRestful = false;

  @override
  void initState() {
    super.initState();
    List<String> strList = ['url', 'cid', 'email', 'username', 'password', 'Restful'];
    Future<Map> rst = get(strList);
    rst.then((Map rstList) {
      _urlController = new TextEditingController(text: rstList[strList[0]]);
      _cidController = new TextEditingController(text: rstList[strList[1]]);
      _emailController = new TextEditingController(text: rstList[strList[2]]);
      _usernameController =
          new TextEditingController(text: rstList[strList[3]]);
      _passwordController =
          new TextEditingController(text: rstList[strList[4]]);
      _useRestful = (rstList[strList[4]]==null || rstList[strList[4]]== "false") ? false : true;
    });
  }

  Future<Map> get(List<String> strList) async {
    Map rst = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String str in strList) {
      rst[str] = prefs.getString(str);
    }
    return rst;
  }

  @override
  Widget build(BuildContext context) {
    save() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('url', _urlController.value.text.toString());
      prefs.setString('cid', _cidController.value.text.toString());
      prefs.setString('email', _emailController.value.text.toString());
      prefs.setString('username', _usernameController.value.text.toString());
      prefs.setString('password', _passwordController.value.text.toString());
      _useRestful ? prefs.setString('restful', 'true') : prefs.setString('restful', 'false');
    }

    bool check() {
      setState(() {
        _urlController.text.isEmpty
            ? _validateUrl = true
            : _validateUrl = false;
        _cidController.text.isEmpty
            ? _validateCid = true
            : _validateCid = false;
        _emailController.text.isEmpty
            ? _validateEmail = true
            : _validateEmail = false;
        _usernameController.text.isEmpty
            ? _validateUsername = true
            : _validateUsername = false;
        _passwordController.text.isEmpty
            ? _validatePassword = true
            : _validatePassword = false;
      });
      if (_validateUrl ||
          _validateCid ||
          _validateEmail ||
          _validateUsername ||
          _validatePassword)
        return true;
      else
        return false;
    }

    checkUrl() {
      setState(() {
        _urlController.text.isEmpty
            ? _validateUrl = true
            : _validateUrl = false;
      });
    }

    checkCid() {
      setState(() {
        _cidController.text.isEmpty
            ? _validateCid = true
            : _validateCid = false;
      });
    }

    checkEmail() {
      setState(() {
        _emailController.text.isEmpty
            ? _validateEmail = true
            : _validateEmail = false;
      });
    }

    checkUsername() {
      setState(() {
        _usernameController.text.isEmpty
            ? _validateUsername = true
            : _validateUsername = false;
      });
    }

    checkPassword() {
      setState(() {
        _passwordController.text.isEmpty
            ? _validatePassword = true
            : _validatePassword = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0),
                icon: Icon(Icons.web),
                labelText: 'URL',
                errorText: _validateUrl ? "请输入 URL" : null,
              ),
              onChanged: (String a) => checkUrl(),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(cidTextFieldNode),
            ),
            TextField(
              focusNode: cidTextFieldNode,
              controller: _cidController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0),
                icon: Icon(Icons.bookmark),
                labelText: 'Cid',
                errorText: _validateCid ? "请输入 cid" : null,
              ),
              onChanged: (String a) => checkCid(),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(emailTextFieldNode),
            ),
            TextField(
              focusNode: emailTextFieldNode,
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0),
                icon: Icon(Icons.email),
                labelText: 'Email',
                errorText: _validateEmail ? "请输入 email" : null,
              ),
              onChanged: (String a) => checkEmail(),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(usernameTextFieldNode),
            ),
            TextField(
              focusNode: usernameTextFieldNode,
              controller: _usernameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0),
                icon: Icon(Icons.account_circle),
                labelText: 'Username',
                errorText: _validateUsername ? "请输入 username" : null,
              ),
              onChanged: (String a) => checkUsername(),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(passwordTextFieldNode),
            ),
            TextField(
              focusNode: passwordTextFieldNode,
              controller: _passwordController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10.0),
                icon: Icon(Icons.lock),
                labelText: 'Password',
                errorText: _validatePassword ? "请输入 password" : null,
              ),
              onChanged: (String a) => checkPassword(),
              obscureText: true,
            ),
//            Checkbox(
//              onChanged: (bool checked){},
//              value: false,
//            ),
            CheckboxListTile(
              title: Text("使用 Restful 方式"),
              subtitle: Text("需要安装插件，默认使用 XMLRPC 方式"),
              onChanged: (bool checked) =>  setState(()=>_useRestful=checked),
              value: _useRestful,
            ),
            OutlineButton(
                child: Text('保存'),
                onPressed: () {
                  if (check()) return;
                  save();
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("数据存储成功")));
                }),
          ],
        ));
      }),
    );
  }
}
