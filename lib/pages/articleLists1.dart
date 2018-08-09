import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:juejin_su/common/config/requestHeader.dart';
import 'package:juejin_su/pages/articleDetail.dart';

class ArticleLists extends StatefulWidget {
  final Map categories;

  @override
  ArticleLists({Key key, this.categories}) : super(key: key);

  ArticleListsState createState() => new ArticleListsState();
}

class ArticleListsState extends State<ArticleLists>
    with AutomaticKeepAliveClientMixin {
  List articleList;

  TextStyle langageStyle = TextStyle(fontSize: 12.0, color: Colors.grey);
  TextStyle buttonStyle = TextStyle(fontSize: 13.0, color: Colors.grey);

  Future getArticle({int limit = 20, String category}) async {
    final String url =
        'https://timeline-merger-ms.juejin.im/v1/get_entry_by_rank?src=${requestHeader['X-Juejin-Src']}&uid=${requestHeader['X-Juejin-Uid']}&device_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}&limit=$limit&category=$category';
    final response = await http.get(Uri.encodeFull(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: getArticle(category: widget.categories['id']),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          articleList = snapshot.data['d']['entrylist'];
          return new ListView.builder(
            itemCount: articleList.length,
            itemBuilder: (context, index) {
              var item = articleList[index];
              return createItem(item);
            },
          );
        } else if (snapshot.hasError) {
          return new Center(child: new Text('error: ${snapshot.error}'));
        }
        return new CupertinoActivityIndicator();
      },
    );
  }

  Widget createItem(articleInfo) {
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
                          backgroundImage: new NetworkImage(
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

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
