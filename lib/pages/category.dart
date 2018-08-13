import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:juejin_su/common/scoped_model/appModel.dart';

class CategoryPage extends StatefulWidget {
  @override
  CategoryPageState createState() => new CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  List dataList;

  @override
  Widget build(BuildContext context) {
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
            title: new Text(
              '首页特别展示',
              style: TextStyle(color: Colors.white),
            )),
        body: ScopedModelDescendant<AppModel>(builder: (context, child, model) {
          List<Widget> list = <Widget>[];
          for (int index = 0; index < model.allMenus.length; index++) {
            list.add(new Container(
                width: double.infinity,
                child: new Padding(
                  padding: EdgeInsets.all(0.0),
                  child: new Column(children: <Widget>[
                  new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 60.0,
                            child: new Icon(
                              Icons.list,
                              size: 30.0,
                              color: Colors.grey[350],
                            ),
                          ),
                          new Expanded(
                              child: new Padding(
                            padding:
                                new EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new Text(
                              model.allMenus[index].name,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          )),
                          new Container(
                              child: Switch(
                                  value: model.allMenus[index].isShow,
                                  onChanged: (bool b) {
                                    model.selectMenu(index);
                                    model.updateMenuShow(b);
                                  }))
                        ],
                      )),
                  new Divider(height: 1.0)
                ]
                )),
              ));
          }
          return new ListView(
              children: list,
              
            );
        }));
  }

}
