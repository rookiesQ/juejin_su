import 'dart:convert' show json;

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:juejin_su/common/model/user.dart';
import 'package:juejin_su/common/model/menu.dart';

class AppModel extends Model with MenuModel {
  final SharedPreferences _sharedPrefs;
  Set<User> _mine = Set();
  static const _MENU_KEY = "menu_key";

  AppModel(this._sharedPrefs) {
    //首页加载，必须放在不然报错
    var m = _sharedPrefs.getString(_MENU_KEY);
    List list;
    if (m != null) {
      list = json.decode(m);
    } else {
      list = homeTab;
      _sharedPrefs.setString(_MENU_KEY, json.encode(homeTab));
    }
    _menu.addAll(list.map((item) => Menu.fromPrefsJson(item)));
  }

  ///首页------------------------------------------------------
  int _index = 2;
  int get index => _index;

  void changeIndex(int i) {
    _index = i;
    notifyListeners();
  }

  ///------------------------------------------------------

  ///TODO
  get mine => _mine;
}

class MenuModel extends Model {
  final SharedPreferences _sharedPrefs;
  static const _MENU_KEY = "menu_key";
  List<Menu> _menu = [];

  List<Menu> get allMenus {
    return List.from(_menu);
  }

  List<Menu> get displaysMenus {
    var display = _menu.where((Menu item) => item.isShow).toList();
    return display;
  }

  ///menu 控制------------------------------------------------------
  List<Menu> get mune {
    return List.from(_menu);
  }

  int _selMenundex;

  int get selectedMenundex {
    return _selMenundex;
  }

  Menu get selectedMenu {
    if (selectedMenundex == null) {
      return null;
    }
    return _menu[selectedMenundex];
  }

  void selectMenu(int index) {
    _selMenundex = index;
    notifyListeners();
    if (index != null) {
      notifyListeners();
    }
  }

  void updateMenuShow(bool isShow) {
    var updatedMenu = _menu[selectedMenundex].toJson();
    updatedMenu['isShow'] = isShow;
    _menu[selectedMenundex] = Menu.fromPrefsJson(updatedMenu);
    notifyListeners();
    _sharedPrefs.setString(_MENU_KEY, json.encode(_menu));
  }
}
