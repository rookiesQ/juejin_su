import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:juejin_su/utils/countTime.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';
import 'dart:convert' show json;

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends ListState<SearchPage> {
  String searchContent;
  String searchString;
  int page = 0;
  bool canRequest = false;

  @override
  bool get isRefreshFirst => false;

  @override
  bool get wantKeepAlive => true;

  search() {
    canRequest = true;
    showRefreshLoading();
  }

  _getDataLogic() async {
    var res = await HttpManager.netFetch(
        Address.search(searchString, page), null, null, null);
    canRequest = false;
    if (res != null && res.data != null) {
      print(json.decode(res.data)['d'].length);
      return new DataResult(json.decode(res.data)['d'], true);
    }
    return new DataResult(null, false);
  }

  @override
  Future<Null> handleRefresh() async {
    if (isLoading || !canRequest) {
      return null;
    }
    page = 0;
    isLoading = true;
    var res = await requestRefresh();
    if (res != null && res.result) {
      pullLoadWidgetControl.dataList.clear();
      if (isShow) {
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    return null;
  }

  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    canRequest = true;
    page++;
    isLoading = true;
    var res = await _getDataLogic();
    if (res != null && res.result) {
      if (isShow) {
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    return null;
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() {}

  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(title: searchInput()),
            body: PullLoadWidget(
              pullLoadWidgetControl,
              (BuildContext context, int index) => _rederItem(index),
              handleRefresh,
              onLoadMore,
              refreshKey: refreshIndicatorKey,
            )));
  }

  searchInput() {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            child: new FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              label: new Text(""),
            ),
            width: 60.0,
          ),
          new Expanded(
            child: new TextField(
              autofocus: true,
              style: new TextStyle(color: Colors.white),
              decoration: new InputDecoration.collapsed(
                  hintText: "搜索",
                  hintStyle: new TextStyle(color: Colors.white),
                  fillColor: Colors.white),
              onChanged: (String content) {
                setState(() {
                  searchContent = content;
                });
              },
              onSubmitted: (String content) {
                if (content.length == null || content.trim().length == 0)
                  return;
                page = 0;
                searchString = content;
                search();
              },
              controller: controller,
            ),
          )
        ],
      ),
      decoration: new BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
      ),
    );
  }

//显示搜索结果
  _rederItem(i) {
    var resultInfo = pullLoadWidgetControl.dataList[i];
    var publicTime = countTime(resultInfo['createdAt']);
    return new Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border(
              bottom: new BorderSide(width: 0.2, color: Colors.grey))),
      child: new FlatButton(
          onPressed: null,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                resultInfo['title'],
                style: new TextStyle(color: Colors.black),
              ),
              new Text(
                '${resultInfo['collectionCount']}人喜欢 · ${resultInfo['user']['username']} · $publicTime',
                textAlign: TextAlign.left,
                style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                softWrap: true,
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    searchContent = null;
    searchString = null;
    super.dispose();
  }
}
