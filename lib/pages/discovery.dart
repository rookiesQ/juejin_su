import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';
import 'package:juejin_su/utils/countTime.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:juejin_su/pages/web.dart';
import 'package:juejin_su/pages/articleDetail.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  DiscoveryPageState createState() => new DiscoveryPageState();
}

class DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: CustomScrollView(slivers: <Widget>[
          new SliverAppBar(
            pinned: true,
            title: new Card(
                color: Colors.blue[600],
                margin: EdgeInsets.all(0.0),
                child: new FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      new Padding(padding: new EdgeInsets.only(right: 5.0)),
                      new Text(
                        '搜索',
                        style: new TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
        ])),
        body: DiscoveryList());
  }
}

class DiscoveryList extends StatefulWidget {
  @override
  DiscoveryListState createState() => new DiscoveryListState();
}

class DiscoveryListState extends ListState<DiscoveryList> {
  List _banner;
  void _getBanner() async {
    var res = await HttpManager.netFetch(Address.getBanner(), null, null, null);
    print(res.data);
    if (res != null && res.data != null) {
      setState(() {
        _banner = res.data['d']['banner'];
      });
    }
  }


  _resquest([rankIndex = '']) async {
    var res = await HttpManager.netFetch(
        Address.getDiscovery('all', rankIndex),
        null,
        null,
        null);
    if (res != null && res.data != null) {
      if (res.data['d']['entrylist'].length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(res.data['d']['entrylist'], true);
    }
    return new DataResult(null, false);
  }

  @override
  requestRefresh() async {
    return await _resquest();
  }

  @override
  requestLoadMore() async {
    ///获取最后一条的rankIndex
    var rankIndex = pullLoadWidgetControl.dataList.last['rankIndex'];
    return await _resquest(rankIndex);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = false;
    _getBanner();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return PullLoadWidget(
      pullLoadWidgetControl,
      (BuildContext contentx, int index) => _renderItem(index),
      handleRefresh,
      onLoadMore,
      refreshKey: refreshIndicatorKey,
    );
  }

  _renderHeader() {
    return new Column(
      children: <Widget>[
        _banner != null
            ? new Container(
                height: 175.0,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    if (_banner[index]['screenshot'] == '') {
                      return new Image.asset('assets/img/juejin.png');
                    }
                    return new Image.network(
                      _banner[index]['screenshot'],
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: _banner.length,
                  onTap: (index) {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) => WebPage(
                                  title: _banner[index]['title'],
                                  url: _banner[index]['url'],
                                )));
                  },
                  duration: 2,
                  autoplay: true,
                ),
              )
            : new Container(),
        new Container(
          color: Colors.white,
          padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
          margin: new EdgeInsets.only(bottom: 20.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                  onPressed: null,
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.whatshot,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      new Text('本周最热')
                    ],
                  )),
              new FlatButton(
                  onPressed: null,
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.collections,
                        color: Colors.green,
                        size: 30.0,
                      ),
                      new Text('收藏集')
                    ],
                  )),
              new FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/activity');
                },
                child: new Column(
                  children: <Widget>[
                    new Icon(
                      Icons.toys,
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                    new Text('活动')
                  ],
                ),
              ),
            ],
          ),
        ),
        new Container(
          padding: new EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: new Border(
                  bottom: new BorderSide(width: 0.2, color: Colors.grey)),
              color: Colors.white),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.whatshot,
                    color: Colors.red,
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 5.0)),
                  new Text(
                    '热门文章',
                    style: new TextStyle(fontSize: 14.0),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 5.0)),
                  new Text(
                    '定制热门',
                    style: new TextStyle(fontSize: 14.0, color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  //单个热门文章
  _renderItem(int i) {
    if (i == 0) return _renderHeader();
    var itemInfo = pullLoadWidgetControl.dataList[i - 1];
    var publicTime = countTime(itemInfo['createdAt']);
    return new Container(
      child: new Column(
        children: <Widget>[
    new Container(
      // shape: ShapeBorder,
      // elevation: 1.0,
      padding: EdgeInsets.all(8.0),
      margin: new EdgeInsets.all(0.0),
      child: new GestureDetector(
        onTap: () {
          var objectId = itemInfo['originalUrl']
              .substring(itemInfo['originalUrl'].lastIndexOf('/') + 1);
          if (itemInfo['original']) {
            Navigator.push(
                context,
                new CupertinoPageRoute(
                    builder: (context) => ArticleDetail(
                          objectId: objectId,
                          articleInfo: itemInfo,
                        )));
          } else {
            Navigator.push(
                context,
                new CupertinoPageRoute(
                    builder: (context) => WebPage(
                          title: itemInfo['title'],
                          url: itemInfo['originalUrl'],
                        )));
          }
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    itemInfo['title'],
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  new Text(
                    '${itemInfo['collectionCount']}人喜欢 · ${itemInfo['user']['username']} · $publicTime',
                    textAlign: TextAlign.left,
                    style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                    softWrap: true,
                  )
                ],
              ),
            ),
            itemInfo['screenshot'] != null
                ? new Image.network(
                    itemInfo['screenshot'],
                    width: 100.0,
                  )
                : new Container(
                    width: 0.0,
                    height: 0.0,
                  )
          ],
        ),
      ),
    ),
          new Divider(height:1.0)
        ]
      ),
    );
  }
}
