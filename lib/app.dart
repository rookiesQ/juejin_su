import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:juejin_su/common/scoped_model/appModel.dart';
import 'package:juejin_su/pages/index.dart';
import 'package:juejin_su/pages/activity.dart';
import 'package:juejin_su/pages/search.dart';
import 'package:juejin_su/pages/category.dart';
import 'package:juejin_su/splashPage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => MaterialApp(
            home: new SplashPage(), //闪屏,
            routes: <String, WidgetBuilder>{
              // '/index': (BuildContext context) => new MyAppsss(
              //     "https://github.com/luhenchang/flutter_study/blob/master/images/longnv5.jpeg?raw=true",
              //     "https://github.com/luhenchang/flutter_study/blob/master/images/longnv5.jpeg?raw=true"),
              '/index': (BuildContext context) => IndexPage(),
              '/activity': (BuildContext context) => ActivityPage(),
              '/search': (BuildContext context) => SearchPage(),
              '/category': (BuildContext context) => CategoryPage(),
            },
          ),
    );
  }
}
