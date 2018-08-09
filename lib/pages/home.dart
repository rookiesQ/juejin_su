import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/pages/articleLists.dart';

List homeTab = [
  {
    "id": "5562b410e4b00c57d9b94a92",
    "name": "Android",
    "title": "android",
    "isSubscribe": false
  },
  {
    "id": "5562b415e4b00c57d9b94ac8",
    "name": "前端",
    "title": "frontend",
    "isSubscribe": false
  },
  {
    "id": "5562b405e4b00c57d9b94a41",
    "name": "iOS",
    "title": "ios",
    "isSubscribe": false
  },
  {
    "id": "569cbe0460b23e90721dff38",
    "name": "产品",
    "title": "product",
    "isSubscribe": false
  },
  {
    "id": "5562b41de4b00c57d9b94b0f",
    "name": "设计",
    "title": "design",
    "isSubscribe": false
  },
  {
    "id": "5562b422e4b00c57d9b94b53",
    "name": "工具资源",
    "title": "freebie",
    "isSubscribe": false
  },
  {
    "id": "5562b428e4b00c57d9b94b9d",
    "name": "阅读",
    "title": "article",
    "isSubscribe": false
  },
  {
    "id": "5562b419e4b00c57d9b94ae2",
    "name": "后端",
    "title": "backend",
    "isSubscribe": false
  },
  {
    "id": "57be7c18128fe1005fa902de",
    "name": "人工智能,",
    "title": "ai",
    "isSubscribe": false
  },
  {
    "id": "5b34a478e1382338991dd3c1",
    "name": "运维",
    "title": "devops",
    "isSubscribe": false
  }
];

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: homeTab.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: implement build
    return new DefaultTabController(
        length: homeTab.length,
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.blue,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: new Container(
                height: double.infinity,
                child: new TabBar(
                    controller: _controller,
                    // indicatorWeight: 4.0,
                    isScrollable:
                        true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，并自动从左到右排列，默认关闭
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.blueGrey[100],
                    indicatorColor: Colors.white,
                    tabs: homeTab.map((tab) {
                      return new Tab(
                        text: tab['name'],
                      );
                    }).toList())),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/shareArticle');
                  })
            ],
          ),
          body: new TabBarView(
              controller: _controller,
              children: homeTab.map((cate) {
                return ArticleLists(
                  categories: cate,
                );
              }).toList()),
        ));
  }
}
