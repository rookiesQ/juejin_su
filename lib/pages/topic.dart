import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/common/config/requestHeader.dart';

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends ListState<TopicPage> {
  @override
  requestRefresh() async {
    Dio dio = new Dio();
    Response response = await dio.get(Uri.encodeFull(
        'https://short-msg-ms.juejin.im/v1/topicList/recommend?uid=${requestHeader['X-Juejin-Uid']}&device_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}&src=${requestHeader['X-Juejin-Src']}'));
    if (response == null) {
      return new DataResult(null, false);
    }
    return new DataResult(response.data['d']['list'], true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  @override
  requestLoadMore() {}

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return PullLoadWidget(
      pullLoadWidgetControl,
      (BuildContext context, int index) => _rederItem(index),
      handleRefresh,
      onLoadMore,
      refreshKey: refreshIndicatorKey,
    );
  }

  //　头部内容
  _rendertop() {
    return new Container(
        width: double.infinity,
        color: const Color(0xFFF5F6FA),
        child: new Column(children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: new CarouselSlider(
                items: [1, 2].map((i) {
                  return new Builder(
                    builder: (BuildContext context) {
                      return new Container(
                          width: MediaQuery.of(context).size.width,
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: new BoxDecoration(color: Colors.amber),
                          child: new Text(
                            'text $i',
                            style: new TextStyle(fontSize: 16.0),
                          ));
                    },
                  );
                }).toList(),
                height: 200.0,
                viewportFraction: 0.9,
                reverse: false,
                aspectRatio: 2.0,
                autoPlay: false),
          ),
          new Container(
              alignment: Alignment.centerLeft,
              child: new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    '更多话题',
                    textAlign: TextAlign.start,
                    style: new TextStyle(fontSize: 15.0),
                  ))),
          new Divider(height: 1.0)
        ]));
  }

  _rederItem(int i) {
    if (i == 0) {
      return _rendertop();
    }
    var data = pullLoadWidgetControl.dataList[i - 1];
    return new InkWell(
        onTap: () {
          print(data);
        },
        child: new Column(children: <Widget>[
          new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new SizedBox(
                            height: 50.0,
                            width: 52.0,
                            child: new Image.network(data['icon']),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  data['title'],
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Text(
                                  "${data['attendersCount']} 关注者 · ${data['msgsCount']} 沸点",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    new Container(
                      width: 60.0,
                      child: new FlatButton(
                        color: Colors.grey[300],
                        // shape: new ShapeBorderClipper()
                        onPressed: () {},
                        child: new Text(
                          '关注',
                          style:
                              new TextStyle(color: Colors.blue, fontSize: 13.0),
                        ),
                      ),
                    )
                  ])),
          new Divider(height: 1.0)
        ]));
  }
}
