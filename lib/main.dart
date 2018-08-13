import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:juejin_su/common/scoped_model/appModel.dart';
import 'package:juejin_su/app.dart';

void main() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(ScopedModel<AppModel>(
      model: AppModel(sharedPreferences), child: MyApp()));
}
