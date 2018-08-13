import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:juejin_su/pages/articleLists.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:juejin_su/common/scoped_model/appModel.dart';
import 'package:juejin_su/widgets/GSYTabBarWidget.dart';
import 'package:juejin_su/pages/category.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController topPageControl = new PageController();

  // @override
  // Widget build(BuildContext context) {
  //   //TODO: implement build
  //   return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
  //     return new DefaultTabController(
  //         length: model.displaysMenus.length,
  //         child: new Scaffold(
  //           appBar: new AppBar(
  //             backgroundColor: Colors.blue,
  //             elevation: 0.0,
  //             automaticallyImplyLeading: false,
  //             title: new Container(
  //                 height: double.infinity,
  //                 child: new TabBar(
  //                     isScrollable: true,
  //                     labelColor: Colors.white,
  //                     unselectedLabelColor: Colors.blueGrey[100],
  //                     indicatorColor: Colors.white,
  //                     tabs: model.displaysMenus.map((tab) {
  //                       return new Tab(
  //                         text: tab.name,
  //                       );
  //                     }).toList())),
  //             actions: <Widget>[
  //               new IconButton(
  //                   icon: new Icon(
  //                     Icons.keyboard_arrow_down,
  //                     color: Colors.white,
  //                   ),
  //                   onPressed: () {
  //                     Navigator.pushNamed(context, '/category').then((v) {});
  //                   })
  //             ],
  //           ),
  //           body: new TabBarView(
  //               children: model.displaysMenus.map((cate) {
  //             return ArticleLists(
  //               categories: cate.toJson(),
  //             );
  //           }).toList()),
  //         ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        rebuildOnChange: true,
        builder: (context, child, model) {
          if (model.displaysMenus.length == 0) {
            return Container();
          }
          List<Widget> list = new List();
          for (int i = 0; i < model.displaysMenus.length; i++) {
            list.add(new GestureDetector(
               onTap: () {
                  topPageControl.jumpTo(MediaQuery.of(context).size.width * i);
                },
              child: new Text(
                  model.displaysMenus[i].name,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white),
                ),
            ));
          }

          return new GSYTabBarWidget(
            type: GSYTabBarWidget.TOP_TITLE,
            tabItems: list,
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) => CategoryPage()));
                  })
            ],
            tabViews: model.displaysMenus.map((cate) {
              return ArticleLists(
                categories: cate.toJson(),
              );
            }).toList(),
            topPageControl: topPageControl,
            backgroundColor: Colors.lightBlue,
            indicatorColor: Colors.white,
            isScrollable: true,
          );
        });
  }
}
