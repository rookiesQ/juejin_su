import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/pages/articleDetail.dart';
import 'package:juejin_su/pages/web.dart';

class ArticleLists extends StatefulWidget {
  final Map categories;

  @override
  ArticleLists({Key key, this.categories}) : super(key: key);

  ArticleListsState createState() => new ArticleListsState();
}

class ArticleListsState extends ListState<ArticleLists> {
  TextStyle langageStyle = TextStyle(fontSize: 12.0, color: Colors.grey);
  TextStyle buttonStyle = TextStyle(fontSize: 13.0, color: Colors.grey);

  _resquest([rankIndex = '']) async {
    var res = await HttpManager.netFetch(
        Address.articleList(widget.categories['id'], before: rankIndex),
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
    var rankIndex = pullLoadWidgetControl.dataList.last['rankIndex'];
    return await _resquest(rankIndex);
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
    var tags = articleInfo['tags'];
    return new Container(
      margin: new EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      padding: new EdgeInsets.only(top: 10.0, left: 10.0),
      child: new FlatButton(
        padding: new EdgeInsets.all(5.0),
        onPressed: () {
          if (articleInfo['original']) {
            var objectId = articleInfo['originalUrl']
                .substring(articleInfo['originalUrl'].lastIndexOf('/') + 1);
            Navigator.push(
                context,
                new CupertinoPageRoute(
                    builder: (context) => ArticleDetail(
                          objectId: objectId,
                          articleInfo: articleInfo,
                        )));
          } else {
            Navigator.push(
                context,
                new CupertinoPageRoute(
                    builder: (context) => WebPage(
                          title: articleInfo['title'],
                          url: articleInfo['originalUrl'],
                        )));
          }
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
                        new Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(25.0),
                            image: new DecorationImage(
                                image: (articleInfo['user']['avatarLarge'] == '' || articleInfo['user']['avatarLarge'] == null)
                                //         // ? (articleInfo['user']['community']['github'] != null
                                //         // ? articleInfo['user']['community']['github']['avatar_url']
                                //         // : (articleInfo['user']['community'] != null
                                //         // ? articleInfo['user']['community']['wechat']['avatarLarge']
                                //         // : (articleInfo['user']['community']['weibo'] != null
                                //         // ? articleInfo['user']['community']['weibo']['avatarLarge']
                                //         // : AssetImage('assets/img/juejin.png'))))
                                        ? AssetImage('assets/img/juejin.png')
                                        : new NetworkImage(articleInfo['user']['avatarLarge'],)
                                ,
                                fit: BoxFit.fill),
                          ),
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
          _renderContent(articleInfo),
        ]),
      ),
      color: Colors.white,
    );
  }

  _renderContent(Map articleInfo) {
    return new Container(
      margin: EdgeInsets.only(right: 5.0, left: 5.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  new Text(
                    articleInfo['title'],
                    style: new TextStyle(fontSize: 15.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  new Text(
                    articleInfo['summaryInfo'],
                    style:
                        new TextStyle(fontSize: 13.0, color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _actionButton(articleInfo)
                ])),
            articleInfo['screenshot'] != ''
                ? new Container(
                    width: 70.0,
                    height: 80.0,
                    margin: EdgeInsets.only(
                      left: 5.0,
                    ),
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(articleInfo['screenshot']),
                            fit: BoxFit.cover)),
                  )
                : new Container()
          ]),
    );
  }

  //红心和message
  Widget _actionButton(Map articleInfo) {
    return new Container(
      child: new Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new IconButton(
            padding: EdgeInsets.all(0.0),
            alignment: Alignment.centerRight,
            onPressed: () {},
            icon: new Icon(
              Icons.favorite,
              color: Colors.grey,
            ),
            iconSize: 15.0,
          ),
          new Container(width: 3.0),
          new Text(
            articleInfo['collectionCount'].toString(),
            style: TextStyle(color: Colors.grey),
          ),
          new Container(
            width: 10.0,
          ),
          new IconButton(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(0.0),
            onPressed: () {},
            icon: new Icon(
              Icons.message,
              color: Colors.grey,
            ),
            iconSize: 14.0,
          ),
          new Container(width: 3.0),
          new Text(articleInfo['commentsCount'].toString(),
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
