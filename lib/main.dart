import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

void main() => runApp(MyApp(
      //通过window.defaultRouteName获取从native传递过来的参数,需要导入dart:ui包
      initParams: window.defaultRouteName,
    ));

class MyApp extends StatelessWidget {
  final String initParams;

  MyApp({Key key, this.initParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_Android混合开发',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(initParams: initParams),
    );
  }
}

class HomePage extends StatefulWidget {
  final String initParams;

  const HomePage({Key key, this.initParams}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //初始化BasicMessageChannel
  static const BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());
  String showMessage = "";

  @override
  void initState() {
    _basicMessageChannel
        .setMessageHandler((String message) => Future<String>(() {
              setState(() {
                showMessage = message;
              });
              return "收到Native的消息：接受成功";
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetRoute(widget.initParams, showMessage),
      ),
    );
  }
}

///路由转发
Widget _widgetRoute(String route, String showMessage) {
  switch (route) {
    case "route1":
      return route1Widget(showMessage);
    case "route2":
      return route2Widget(showMessage);
    default:
      return notFoundWidget(showMessage);
  }
}

Widget route1Widget(String showMessage) {
  return Center(
    child: Text(
      "this is route1Widget$showMessage",
      style: TextStyle(color: Colors.red, fontSize: 20),
    ),
  );
}

Widget route2Widget(String showMessage) {
  return Center(
    child: Text(
      "this is route2Widget$showMessage",
      style: TextStyle(color: Colors.blue, fontSize: 20),
    ),
  );
}

Widget notFoundWidget(String showMessage) {
  return Center(
    child: Text(
      "未匹配到路由111$showMessage",
      style: TextStyle(fontSize: 40),
    ),
  );
}
