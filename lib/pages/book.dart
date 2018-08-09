import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:juejin_su/utils/countTime.dart';
import 'package:juejin_su/common/config/requestHeader.dart';

class BookPage extends StatefulWidget {
  @override
  BookPageState createState() => new BookPageState();
}

class BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List books;

  int currentIndex;
  bool flag = false;

  Future getBooks({pageNum: 1}) async {
    final response = await http.get(Uri.encodeFull(
        'https://xiaoce-timeline-api-ms.juejin.im/v1/getListByLastTime?uid=${requestHeader['X-Juejin-Uid']}&client_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}&src=${requestHeader['X-Juejin-Src']}&pageNum=$pageNum'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  void initState() {
    super.initState();
    this.getBooks();
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
          new FutureBuilder(
              future: getBooks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  books = snapshot.data['d'];
                  return new CustomScrollView(
                    slivers: <Widget>[
                      new SliverList(
                          delegate:
                              new SliverChildBuilderDelegate((context, index) {
                        var itemInfo = books[index];
                        return createItem(itemInfo);
                      }, childCount: books.length)),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("error:${snapshot.error}");
                }
                return new Container(
                  color: new Color.fromRGBO(244, 245, 245, 1.0),
                  child: new CupertinoActivityIndicator(),
                );
              }),
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

//单个小册
  Widget createItem(itemInfo) {
    return new Container(
      padding: new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border(
              bottom: new BorderSide(width: 0.2, color: Colors.grey))),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: 60.0,
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                  offset: new Offset(1.0, 2.0),
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                  color: Colors.grey)
            ]),
            child: new Image.network(itemInfo['img']),
          ),
          new Expanded(
              child: new Padding(
            padding: new EdgeInsets.only(left: 10.0, right: 10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  itemInfo['title'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Text(
                  itemInfo['userData']['username'],
                  style: new TextStyle(fontSize: 14.0),
                ),
                new Text(
                  '${itemInfo['section'].length +
                          1}小姐·${itemInfo['buyCount']}人已购买',
                  style: new TextStyle(
                      fontSize: 12.0, color: Colors.grey, letterSpacing: 2.0),
                )
              ],
            ),
          )),
          new ActionChip(
            label: new Text(
              '￥${itemInfo['price']}',
              style: new TextStyle(color: Colors.blueAccent),
            ),
            backgroundColor: new Color.fromARGB(1, 225, 225, 225),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
