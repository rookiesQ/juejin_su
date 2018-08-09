import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:juejin_su/pages/home.dart';
import 'package:juejin_su/pages/book.dart';
import 'package:juejin_su/pages/discovery.dart';
import 'package:juejin_su/pages/hot.dart';
import 'package:juejin_su/pages/mine.dart';
import 'package:scoped_model/scoped_model.dart';

class IndexPage extends StatefulWidget {
  @override
  createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text('确定要退出应用？'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('取消')),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('确定'))
              ],
            ));
  }

  ///
  final List<Widget> tabBody = [
    new HomePage(),
    new DiscoveryPage(),
    new HotPage(),
    new BookPage(),
    new MinePage()
  ];

  int _index = 0;
  Widget currentPage; //当前页面

  @override
  void initState() {
    super.initState();
    currentPage = tabBody[_index];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new ScopedModel<IndexModel>(
        model: IndexModel(),
        child: new Scaffold(
          bottomNavigationBar: new Container(
              height: 48.0,
              width: double.infinity,
              child: new Column(children: <Widget>[
                new Divider(
                  height: 0.0,
                ),
                new Container(
                  height: 48.0,
                  width: double.infinity,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new _ButtonNavigation(0),
                      new _ButtonNavigation(1),
                      new _ButtonNavigation(2),
                      new _ButtonNavigation(3),
                      new _ButtonNavigation(4),
                    ],
                  ),
                )
              ])),
          body: new ScopedModelDescendant<IndexModel>(
            builder: (ctx, child, model) {
              return new IndexedStack(
                children: tabBody,
                index: model._index,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ButtonNavigation extends StatefulWidget {
  final int index;

  _ButtonNavigation(this.index);

  @override
  createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<_ButtonNavigation> {
  final List _iconList = [
    CupertinoIcons.home,
    CupertinoIcons.search,
    CupertinoIcons.conversation_bubble,
    CupertinoIcons.book,
    CupertinoIcons.profile_circled,
  ];

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<IndexModel>(
      builder: (ctx, child, model) {
        return new Expanded(
          child: new Container(
            width: double.infinity,
            child: new IconButton(
              icon: Icon(_iconList[widget.index]),
              color:
                  widget.index == model._index ? Colors.blue : Colors.black87,
              onPressed: () {
                model.changeIndex(widget.index);
              },
            ),
          ),
        );
      },
    );
  }
}

class IndexModel extends Model {
  int _index = 0;

  void changeIndex(int i) {
    _index = i;
    notifyListeners();
  }
}
