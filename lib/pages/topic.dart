import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends ListState<TopicPage> {
  @override
  requestRefresh() async {
    var res =
        await HttpManager.netFetch(Address.getTopicList(), null, null, null);
    if (res != null && res.data != null) {
      if (res.data['d']['list'].length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(res.data['d']['list'], true);
    }
    return new DataResult(null, false);
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
                        new Container(
                          width: 50.0,
                          height: 52.0,
                          margin: const EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data['icon']),
                                  fit: BoxFit.cover),
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(8.0),
                              )),
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
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                new Text(
                                  "${data['attendersCount']} 关注者 · ${data['msgsCount']} 沸点",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    new ActionChip(
                      label: new Text(
                        '关注',
                        style: new TextStyle(color: Colors.blueAccent),
                      ),
                      backgroundColor: const Color(0XFFEEEEEE),
                      onPressed: () {},
                    )
                  ])),
          new Divider(height: 1.0)
        ]));
  }
}
