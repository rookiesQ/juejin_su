import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/pages/topic.dart';
import 'package:juejin_su/widgets/GSYTabBarWidget.dart';

class HotPage extends StatefulWidget {
  @override
  _HotPageState createState() => new _HotPageState();
}

class _HotPageState extends State<HotPage> {
  final PageController topPageControl = new PageController();

  _renderTab() {
    List<String> tab = ['话题', '推荐', '动态'];
    List<Widget> list = new List();
    for (int i = 0; i < tab.length; i++) {
      list.add(new FlatButton(
        onPressed: () {
          topPageControl.jumpTo(MediaQuery.of(context).size.width * i);
        },
        child: new Text(
          tab[i],
          maxLines: 1,
        ),
        textColor: Colors.white,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new GSYTabBarWidget(
      type: GSYTabBarWidget.TOP_TITLE,
      tabItems: _renderTab(),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.pushNamed(context, '/putHot');
            })
      ],
      tabViews: <Widget>[
        new TopicPage(),
        new Center(child: new Text('TODO')),
        new Center(child: new Text('TODO')),
      ],
      topPageControl: topPageControl,
      backgroundColor: Colors.lightBlue,
      indicatorColor: Colors.white,
    );
  }
}
