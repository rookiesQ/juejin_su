import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/pages/articleDetail.dart';

class ArticleLists extends StatefulWidget {
  final Map categories;

  @override
  ArticleLists({Key key, this.categories}) : super(key: key);

  ArticleListsState createState() => new ArticleListsState();
}

class ArticleListsState extends ListState<ArticleLists> {
  TextStyle langageStyle = TextStyle(fontSize: 12.0, color: Colors.grey);
  TextStyle buttonStyle = TextStyle(fontSize: 13.0, color: Colors.grey);

  @override
  requestRefresh() async {
    var res = await HttpManager.netFetch(
        Address.homeCategory(widget.categories['id']), null, null, null);
    if (res != null && res.data != null) {
      if (res.data['d']['entrylist'].length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(res.data['d']['entrylist'], true);
    }
    return new DataResult(null, false);
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
    super.initState();
  }

  @override
  requestLoadMore() async {
    ///获取最后一条的rankIndex
    var rankIndex = pullLoadWidgetControl
        .dataList[pullLoadWidgetControl.dataList.length - 1]['rankIndex'];
    var res = await HttpManager.netFetch(
        Address.homeCategory(widget.categories['id'], before: rankIndex),
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

  _rederItem(int i) {
    var articleInfo = pullLoadWidgetControl.dataList[i];
    var objectId = articleInfo['originalUrl']
        .substring(articleInfo['originalUrl'].lastIndexOf('/') + 1);
    var tags = articleInfo['tags'];
    return new Container(
      margin: new EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      padding: new EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: new FlatButton(
        padding: new EdgeInsets.all(5.0),
        onPressed: () {
          Navigator.push(
              context,
              new CupertinoPageRoute(
                  builder: (context) => ArticleDetail(
                        objectId: objectId,
                        articleInfo: articleInfo,
                      )));
        },
        child: new Column(children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new FlatButton(
                    onPressed: null,
                    padding: new EdgeInsets.all(5.0),
                    child: new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage:
                              articleInfo['user']['avatarLarge'] == ''
                                  ? new AssetImage('assets/img/juejin.png')
                                  : new NetworkImage(
                                      articleInfo['user']['avatarLarge']),
                        ),
                        new Padding(padding: new EdgeInsets.only(right: 5.0)),
                        new Text(articleInfo['user']['username'],
                            style: new TextStyle(color: Colors.black))
                      ],
                    )),
                new Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: tags.isNotEmpty
                      ? (tags.length >= 2
                          ? new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Text(
                                  tags[0]['title'].toString(),
                                  style: langageStyle,
                                ),
                                new Text(
                                  '/',
                                  style: new TextStyle(letterSpacing: 5.0),
                                ),
                                new Text(
                                  tags[1]['title'].toString(),
                                  style: langageStyle,
                                )
                              ],
                            )
                          : new Text(
                              tags[0]['title'].toString(),
                              style: langageStyle,
                            ))
                      : new Container(width: 0.0),
                ),
              ]),
          new ListTile(
            contentPadding: EdgeInsets.only(left: 5.0),
            title: new Text(articleInfo['title']),
            subtitle: new Text(
              articleInfo['summaryInfo'],
              maxLines: 2,
            ),
          ),
          _actionButton(articleInfo)
        ]),
      ),
      color: Colors.white,
    );
  }

  //红心和message
  Widget _actionButton(Map articleInfo) {
    return new Container(
      child: new Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new FlatButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () {},
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 5.0)),
                  new Text(
                    articleInfo['collectionCount'].toString(),
                    style: buttonStyle,
                  )
                ],
              )),
          new FlatButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () {},
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.message,
                    color: Colors.grey,
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 5.0)),
                  new Text(
                    articleInfo['commentsCount'].toString(),
                    style: buttonStyle,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
