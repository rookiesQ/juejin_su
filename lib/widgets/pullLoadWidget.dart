import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///通用下上刷新控件
class PullLoadWidget extends StatefulWidget {
  ///item渲染
  final IndexedWidgetBuilder itemBuilder;

  ///加载更多回调
  final RefreshCallback onLoadMore;

  ///下拉刷新回调
  final RefreshCallback onRefresh;

  ///控制器，比如数据和一些配置
  final PullLoadWidgetControl control;

  final Key refreshKey;

  PullLoadWidget(
      this.control, this.itemBuilder, this.onRefresh, this.onLoadMore,
      {this.refreshKey});

  @override
  _PullLoadWidgetState createState() => _PullLoadWidgetState(this.control,
      this.itemBuilder, this.onRefresh, this.onLoadMore, this.refreshKey);
}

class _PullLoadWidgetState extends State<PullLoadWidget> {
  final IndexedWidgetBuilder itemBuilder;

  final RefreshCallback onLoadMore;

  final RefreshCallback onRefresh;

  final Key refreshKey;

  PullLoadWidgetControl control;

  _PullLoadWidgetState(this.control, this.itemBuilder, this.onRefresh,
      this.onLoadMore, this.refreshKey);

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (this.onLoadMore != null && this.control.needLoadMore) {
          this.onLoadMore();
        }
      }
    });
    super.initState();
  }

  _getListCount() {
    if (control.needHeader) {
      return (control.dataList.length > 0)
          ? control.dataList.length + 2
          : control.dataList.length + 1;
    } else {
      if (control.dataList.length == 0) {
        return 1;
      }
      return (control.dataList.length > 0)
          ? control.dataList.length + 1
          : control.dataList.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: refreshKey,
      onRefresh: onRefresh,
      child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (!control.needHeader &&
              index == control.dataList.length &&
              control.dataList.length != 0) {
            return _buildProgressIndicator();
          } else if (control.needHeader &&
              index == _getListCount() - 1 &&
              control.dataList.length != 0) {
            return _buildProgressIndicator();
          } else if (!control.needHeader && control.dataList.length == 0) {
            return _buildEmpty();
          } else {
            return itemBuilder(context, index);
          }
        },
        itemCount: _getListCount(),
        controller: _scrollController,
      ),
    );
  }

  Widget _buildEmpty() {
    return new Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: new Text('加载中...', style: new TextStyle(color: Colors.grey)),
          ),
          Container(
            child: Text('目前什么也没有哟', style: new TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    Widget bottomWidget = (control.needLoadMore)
        ? new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                new SpinKitRotatingCircle(color: Color(0xFF24292E)),
                new Container(
                  width: 5.0,
                ),
                new Text(
                  '正在加载更多',
                  style: new TextStyle(color: Color(0xFF121917)),
                )
              ])
        : new Text('没有更多数据', style: new TextStyle(color: Color(0xFF121917)));
    return new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
        child: bottomWidget,
      ),
    );
  }
}

class PullLoadWidgetControl {
  ///数据，对齐增减，不能替换
  List dataList = new List();

  ///是否需要加载更多
  bool needLoadMore = true;

  ///是否需要头部
  bool needHeader = false;
}
