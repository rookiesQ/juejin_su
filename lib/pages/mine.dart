import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:juejin_su/common/scoped_model/appModel.dart';

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => new MinePageState();
}

class MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '我',
          style: new TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: new ListView(
        children: <Widget>[
          _renderItem(),
          new Column(
              children: infoList.map((item) {
            Map itemInfo = item['content'];
            return new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(bottom: new BorderSide(width: 0.2))),
              child: new ListTile(
                leading: new Icon(
                  itemInfo['icon'],
                  color: itemInfo['color'],
                ),
                title: new Text(itemInfo['title']),
                trailing: itemInfo['count'] == null
                    ? new Container(
                        width: 0.0,
                        height: 0.0,
                      )
                    : new Text(itemInfo['count'].toString()),
                onTap: () {
                  Navigator.pushNamed(context, itemInfo['path']);
                },
              ),
            );
          }).toList()),
          new Column(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(top: 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border(
                        top: new BorderSide(width: 0.2),
                        bottom: new BorderSide(width: 0.2))),
                child: new ListTile(
                  leading: new Icon(Icons.insert_drive_file),
                  title: new Text('意见反馈'),
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(bottom: 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border(bottom: new BorderSide(width: 0.2))),
                child: new ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text('设置'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _renderItem() {
    return new ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
      return new Container(
        alignment: Alignment.center,
        child: new ListTile(
          leading: new CircleAvatar(
            child: new Icon(Icons.person, color: Colors.white),
            backgroundColor: Colors.grey,
          ),
          title: new Text('登录/注册'),
          subtitle: new Container(
            width: 0.0,
            height: 0.0,
          ),
          enabled: true,
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.pushNamed(context, '/signin');
          },
        ),
        padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
        margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        decoration: const BoxDecoration(
            border: const Border(
              top: const BorderSide(
                  width: 0.2, color: const Color.fromRGBO(215, 217, 220, 1.0)),
              bottom: const BorderSide(
                  width: 0.2, color: const Color.fromRGBO(215, 217, 220, 1.0)),
            ),
            color: Colors.white),
      );
    });
  }
}

List infoList = [
  {
    'key': 'msgCenter',
    'content': {
      'title': '消息中心',
      'icon': Icons.notifications,
      'color': Colors.blue,
      'path': '/msgCenter'
    }
  },
  {
    'key': 'collectedEntriesCount',
    'content': {
      'title': '我喜欢的',
      'icon': Icons.favorite,
      'color': Colors.green,
      'path': '/like'
    }
  },
  {
    'key': 'collectionSetCount',
    'content': {
      'title': '收藏集',
      'icon': Icons.collections,
      'color': Colors.blue,
      'path': '/collections'
    }
  },
  {
    'key': 'postedEntriesCount',
    'content': {
      'title': '已购小册',
      'icon': Icons.shop,
      'color': Colors.orange,
      'path': '/myBooks'
    }
  },
  {
    'key': 'collectionSetCount',
    'content': {
      'title': '我的钱包',
      'icon': Icons.account_balance_wallet,
      'color': Colors.blue,
      'path': '/myWallet'
    }
  },
  {
    'key': 'likedPinCount',
    'content': {
      'title': '赞过的沸点',
      'icon': Icons.thumb_up,
      'color': Colors.green,
      'path': '/pined'
    }
  },
  {
    'key': 'viewedEntriesCount',
    'content': {
      'title': '阅读过的文章',
      'icon': Icons.remove_red_eye,
      'color': Colors.grey,
      'path': '/read'
    }
  },
  {
    'key': 'subscribedTagsCount',
    'content': {
      'title': '标签管理',
      'icon': Icons.picture_in_picture,
      'color': Colors.grey,
      'path': '/tags'
    }
  },
];
