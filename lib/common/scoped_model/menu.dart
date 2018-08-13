import 'dart:convert';
import 'package:juejin_su/common/model/menu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuModel extends Model {
  final SharedPreferences _sharedPrefs;
  static const _MENU_KEY = "menu_key";
  List<Menu> _menu = [];

  List<Menu> get allMenus {
    return List.from(_menu);
  }

  List<Menu> get displaysMenus {
    var display = _menu.where((Menu item) => item.isShow).toList();
    if (display.length == 0) {
      for (var item in homeTab) {
        _menu.add(Menu.fromPrefsJson(item));
      }
      return _menu;
    }
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
