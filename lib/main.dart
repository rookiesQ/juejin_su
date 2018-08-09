import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:juejin_su/pages/index.dart';
import 'package:juejin_su/pages/activity.dart';
import 'package:juejin_su/pages/search.dart';
import 'package:juejin_su/actions/actions.dart';
import 'package:juejin_su/reducers/reducers.dart';

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:juejin_su/common/config/requestHeader.dart';

void main() {
  final userInfo = new Store<Map>(getUserInfo, initialState: {});

  runApp(new MyApp(
    store: userInfo,
  ));
}

class MyApp extends StatelessWidget {
  final Store<Map> store;

  MyApp({Key key, this.store}) : super(key: key);

// void getData() async{
//     Dio dio = new Dio();
//     Response response = await dio.get(Uri.encodeFull('https://short-msg-ms.juejin.im/v1/topicList/recommend?uid=${requestHeader['X-Juejin-Uid']}&device_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}&src=${requestHeader['X-Juejin-Src']}'));
//     print(response.data['d']);
// }
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new MaterialApp(
          home: new IndexPage(),
          theme: new ThemeData(
            highlightColor: Colors.transparent,
            //将点击高亮色设为透明
            splashColor: Colors.transparent,
            //将喷溅颜色设为透明
            bottomAppBarColor: new Color.fromRGBO(244, 245, 245, 1.0),
            //设置底部导航的背景色
            scaffoldBackgroundColor: new Color.fromRGBO(244, 245, 245, 1.0),
            //设置页面背景颜色
            primaryIconTheme: new IconThemeData(color: Colors.blue),
            //主要icon样式，如头部返回icon按钮
            indicatorColor: Colors.blue,
            //设置tab指示器颜色
            iconTheme: new IconThemeData(size: 18.0),
            //设置icon样式
            primaryTextTheme: new TextTheme(
                //设置文本样式
                title: new TextStyle(color: Colors.black, fontSize: 16.0)),
          ),
          routes: <String, WidgetBuilder>{
            '/activity': (BuildContext context) => ActivityPage(),
            '/search': (BuildContext context) => SearchPage()
          },
        ));
  }
}
