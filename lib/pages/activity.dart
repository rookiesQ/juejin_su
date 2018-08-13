import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/utils/countTime.dart';
import 'package:juejin_su/common/net/address.dart';
import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/common/net/api.dart';

class ActivityPage extends StatefulWidget {
  @override
  createState() => new ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> {
  List categoryList = [
    {'cityName': "全部", 'cityAlias': ""},
    {'cityName': "北京", 'cityAlias': "beijing"},
    {'cityName': "上海", 'cityAlias': "shanghai"},
    {'cityName': "广州", 'cityAlias': "guangzhou"},
    {'cityName': "深圳", 'cityAlias': "shenzhen"},
    {'cityName': "杭州", 'cityAlias': "hangzhou"},
  ];
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: categoryList.length,
        child: new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
                icon: new Icon(
                  Icons.chevron_left,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: new Text(
              '活动',
              style: new TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            bottom: new TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.blueGrey[200],
                tabs: categoryList.map((tab) {
                  return new Tab(text: tab['cityName']);
                }).toList()),
          ),
          body: new TabBarView(
              children: categoryList.map((cate) {
            return ActivityList(
              categories: cate,
            );
          }).toList()),
        ));
  }
}

class ActivityList extends StatefulWidget {
  final Map categories;

  @override
  ActivityList({Key key, this.categories}) : super(key: key);

  ActivityListState createState() => new ActivityListState();
}

class ActivityListState extends ListState<ActivityList> {
  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  int pageNum = 0;

  @override
  requestRefresh() async {
    var res = await HttpManager.netFetch(
        Address.eventList(cityAlias: widget.categories['cityAlias']),
        null,
        null,
        null);
    if (res != null && res.data != null) {
      if (res.data['d'].length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(res.data['d'], true);
    }
    return new DataResult(null, false);
  }

  @override
  requestLoadMore() async {
    pageNum++;
    var res = await HttpManager.netFetch(
        Address.eventList(
            pageNum: pageNum, cityAlias: widget.categories['cityAlias']),
        null,
        null,
        null);
    if (res != null && res.data != null) {
      if (res.data['d'].length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(res.data['d'], true);
    }
    return new DataResult(null, false);
  }

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

  ///单个活动项
  _rederItem(int i) {
    // if(pullLoadWidgetControl.dataList.length == 0){
    //   return null;
    // }
    var itemInfo = pullLoadWidgetControl.dataList[i];
    return new Container(
        margin: new EdgeInsets.only(top: 10.0),
        child: new Column(
          children: <Widget>[
            new Image.network(itemInfo['screenshot']),
            new Container(
              margin: new EdgeInsets.only(bottom: 10.0),
              color: Colors.white,
              padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(itemInfo['title'],
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.left),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.date_range),
                      new Padding(padding: new EdgeInsets.only(right: 5.0)),
                      new Text(countTime(itemInfo['endTime']))
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.location_on),
                          new Padding(padding: new EdgeInsets.only(right: 5.0)),
                          new Text(itemInfo['city'])
                        ],
                      ),
                      new ActionChip(
                        label: new Text(
                          '报名参加',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          return null;
                        },
                        backgroundColor: Colors.blue,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
