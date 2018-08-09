import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:juejin_su/common/config/requestHeader.dart';
import 'package:juejin_su/pages/topic.dart';

class HotPage extends StatefulWidget {
  @override
  HotPageState createState() => new HotPageState();
}

class HotPageState extends State<HotPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              new Tab(
                text: '话题',
              ),
              new Tab(
                text: '推荐',
              ),
              new Tab(
                text: '动态',
              ),
            ],
          ),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.mode_edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/putHot');
                })
          ],
        ),
        body: new TabBarView(children: [
          new TopicPage(),
          new Center(child: new Text('2')),
          new Center(child: new Text('3')),
        ]),
      ),
    );
  }
}
