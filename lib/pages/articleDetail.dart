import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:juejin_su/common/config/requestHeader.dart';

class ArticleDetail extends StatefulWidget {
  final String objectId;
  final Map articleInfo;

  @override
  ArticleDetail({Key key, this.objectId, this.articleInfo}) : super(key: key);

  @override
  ArticleDetailState createState() => new ArticleDetailState();
}

class ArticleDetailState extends State<ArticleDetail> {
  Future getContent() async {
    final String url =
        'https://post-storage-api-ms.juejin.im/v1/getDetailData?uid=${requestHeader['X-Juejin-Src']}&device_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}&src=${requestHeader['X-Juejin-Src']}&type=entryView&postId=${widget
        .objectId}';
    final response = await http.get(Uri.encodeFull(url));
    if (response.statusCode == 200) {
      return json.decode(response.body)['d'];
    } else {
      throw Exception('Failed to load content');
    }
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

  Widget _content(BuildContext ctx, Map data, String content) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: new Color.fromRGBO(244, 245, 245, 1.0),
        leading: new IconButton(
          padding: EdgeInsets.all(0.0),
          icon: new Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(ctx),
        ),
        title: new Row(children: <Widget>[
          new CircleAvatar(
            backgroundImage: new NetworkImage(data['user']['avatarLarge']),
          ),
          new Padding(padding: new EdgeInsets.only(right: 5.0)),
          new Text(data['user']['username'])
        ]),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.file_upload, color: Colors.blue),
              onPressed: null)
        ],
      ),
      bottomNavigationBar: _getBottomNavigation(data),
      body: new ListView(children: <Widget>[
        new Container(color: Colors.white, child: new HtmlView(data: content))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var articleInfo = widget.articleInfo;
    return new FutureBuilder(
      future: getContent(),
      builder: (context, ret) {
        if (ret.hasData) {
          return _content(context, articleInfo, ret.data['content']);
        } else if (ret.hasError) {
          return new Container(
            color: Colors.white,
            child: new Text("error: ${ret.error}"),
          );
        }
        //菊花加载
        return new Container(
          color: new Color.fromRGBO(244, 245, 245, 1.0),
          child: new CupertinoActivityIndicator(),
        );
      },
    );
  }
}
