import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/pages/bookList.dart';

class BookPage extends StatefulWidget {
  @override
  BookPageState createState() => new BookPageState();
}

class BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  int currentIndex;
  bool flag = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    currentIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: new Container(
              width: 180.0,
              height: double.infinity,
              child: new TabBar(
                  controller: _controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blueGrey[100],
                  indicatorColor: Colors.white,
                  tabs: [new Tab(text: '全部'), new Tab(text: '已购')]),
            )),
        body: new TabBarView(controller: _controller, children: [
          new BookListPage(),
          new Container(
              color: Colors.white,
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(
                      Icons.book,
                      size: 100.0,
                      color: Colors.blue,
                    ),
                    new Text(
                      '暂无已购小册',
                      style: new TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ))
        ]));
  }
}
