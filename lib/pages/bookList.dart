import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/widgets/ListState.dart';
import 'package:juejin_su/widgets/pullLoadWidget.dart';
import 'package:juejin_su/common/dao/daoResult.dart';
import 'package:juejin_su/common/net/api.dart';
import 'package:juejin_su/common/net/address.dart';

import 'package:juejin_su/pages/web.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends ListState<BookListPage> {
  int pageNum = 1;

  _request([pageNum = 1]) async {
    var res = await HttpManager.netFetch(
        Address.getBookList(pageNum), null, null, null);
    if (res != null && res.data != null) {
      if (res.data['d'].length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(res.data['d'], true);
    }
    return new DataResult(null, false);
  }

  @override
  requestRefresh() async {
    pageNum = 1;
    return await _request(pageNum);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  void initState() {
    super.initState();
  }

  @override
  requestLoadMore() async {
    pageNum++;
    return await _request(pageNum);
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

  ///单个小册
  _rederItem(int i) {
    var itemInfo = pullLoadWidgetControl.dataList[i];
    return new Container(
        child: new InkWell(
            onTap: () {
              print(itemInfo);
            },
            child: new Container(
              padding: new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: new BorderSide(width: 0.2, color: Colors.grey))),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: 60.0,
                    decoration: new BoxDecoration(boxShadow: [
                      new BoxShadow(
                          offset: new Offset(1.0, 2.0),
                          spreadRadius: 1.0,
                          blurRadius: 5.0,
                          color: Colors.grey)
                    ]),
                    child: new Image.network(itemInfo['img']),
                  ),
                  new Expanded(
                      child: new Padding(
                    padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          itemInfo['title'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Text(
                          itemInfo['userData']['username'],
                          style: new TextStyle(fontSize: 14.0),
                        ),
                        new Text(
                          '${itemInfo['section'].length + 1}小姐·${itemInfo['buyCount']}人已购买',
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              letterSpacing: 2.0),
                        )
                      ],
                    ),
                  )),
                  new ActionChip(
                    label: new Text(
                      '￥${itemInfo['price']}',
                      style: new TextStyle(color: Colors.blueAccent),
                    ),
                    backgroundColor: new Color.fromARGB(1, 225, 225, 225),
                    onPressed: () {},
                  )
                ],
              ),
            )));
  }
}
