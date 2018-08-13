import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class ArticleDetail extends StatefulWidget {
  final String objectId;
  final Map articleInfo;

  @override
  ArticleDetail({Key key, this.objectId, this.articleInfo}) : super(key: key);

  @override
  ArticleDetailState createState() => new ArticleDetailState();
}

class ArticleDetailState extends State<ArticleDetail> {
  String content;

  _requestData() async {
    var res = await HttpManager.netFetch(
        Address.article(widget.objectId), null, null, null);
    if (res != null && res.data != null && res.data['d'] != null) {
      setState(() {
        content = res.data['d']['content'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestData();
  }

  ///底部按钮
  Widget _getBottomNavigation(Map data) {
    return new Container(
      height: 50.0,
      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: new Color.fromRGBO(244, 245, 245, 1.0),
          border:
              new Border(top: new BorderSide(width: 0.2, color: Colors.grey))),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Icon(
                  Icons.favorite_border,
                  color: Colors.green,
                  size: 24.0,
                ),
                new Padding(padding: new EdgeInsets.only(right: 20.0)),
                new Icon(
                  Icons.message,
                  color: Colors.grey,
                  size: 24.0,
                ),
                new Padding(padding: new EdgeInsets.only(right: 20.0)),
                new Icon(
                  Icons.playlist_add,
                  color: Colors.grey,
                  size: 24.0,
                )
              ],
            ),
            new Text(
                '喜欢 ${data['collectionCount']} · 评论 ${data['commentsCount']}')
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var articleInfo = widget.articleInfo;
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          padding: EdgeInsets.all(0.0),
          icon: new Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: new Row(children: <Widget>[
          new CircleAvatar(
            backgroundImage:
                new NetworkImage(articleInfo['user']['avatarLarge']),
          ),
          new Padding(padding: new EdgeInsets.only(right: 5.0)),
          new Text(
            articleInfo['user']['username'],
            style: new TextStyle(color: Colors.white),
          )
        ]),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.share, color: Colors.white),
              onPressed: () {})
        ],
      ),
      bottomNavigationBar: _getBottomNavigation(articleInfo),
      body: new ListView(children: <Widget>[
        content == null
            ? new Column(children: <Widget>[
                new Container(
                  color: new Color.fromRGBO(244, 245, 245, 1.0),
                  child: new CupertinoActivityIndicator(),
                )
              ])
            : new Container(
                color: Colors.white, child: new HtmlView(data: content))
      ]),
    );
  }
}
