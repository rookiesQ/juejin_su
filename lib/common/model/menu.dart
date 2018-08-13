var homeTab = [
  {
    "id": "all",
    "name": "推荐",
    "title": "all",
    "createdAt": "2016-04-21T19:19:13Z",
    "updatedAt": "2015-05-24T21:33:04Z",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/225aafca3a440e5d.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/ec8d337c485c4db2.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5562b410e4b00c57d9b94a92",
    "name": "Android",
    "title": "android",
    "createdAt": "2016-04-21T19:19:13Z",
    "updatedAt": "2015-05-24T21:33:04Z",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/225aafca3a440e5d.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/ec8d337c485c4db2.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5562b415e4b00c57d9b94ac8",
    "name": "前端",
    "title": "frontend",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/1c40f5eaba561e32.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/8c95587526f346c0.png",
    "isShow": true,
    "isSubscribe": true
  },
  {
    "id": "5562b405e4b00c57d9b94a41",
    "name": "iOS",
    "title": "ios",
    "createdAt": "2016-04-21T19:19:10Z",
    "updatedAt": "2015-05-24T21:32:54Z",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/4a218bdf1f6969fd.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/34589746327a360a.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "569cbe0460b23e90721dff38",
    "name": "产品",
    "title": "product",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/057d8e19e6405697.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/91e7ff7e6447c6cc.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5562b41de4b00c57d9b94b0f",
    "name": "设计",
    "title": "design",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/3627821e57ceecb9.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/784dddfade84f1c9.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5562b422e4b00c57d9b94b53",
    "name": "工具资源",
    "title": "freebie",
    "createdAt": "2016-03-09T00:38:40Z",
    "updatedAt": "2015-05-24T21:33:22Z",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/eb20ab1334d9abea.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/412957a61f414c0b.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5562b428e4b00c57d9b94b9d",
    "name": "阅读",
    "title": "article",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/20f56d7df9f97d1d.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/228be0376b22924b.png",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5562b419e4b00c57d9b94ae2",
    "name": "后端",
    "title": "backend",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/a2ec01b816abd4c5.png",
    "background": "https://lc-mhke0kuv.cn-n1.lcfile.com/fb3b208d06e6fe32.png",
    "isShow": true,
    "isSubscribe": true
  },
  {
    "id": "57be7c18128fe1005fa902de",
    "name": "人工智能",
    "title": "ai",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/9b525117507d7a76c4ac.png",
    "background":
        "https://lc-mhke0kuv.cn-n1.lcfile.com/f7cecf8806e8621ef35e.jpg",
    "isShow": true,
    "isSubscribe": false
  },
  {
    "id": "5b34a478e1382338991dd3c1",
    "name": "运维",
    "title": "devops",
    "icon": "https://lc-mhke0kuv.cn-n1.lcfile.com/19b30d4c74c80181b5de.png",
    "background":
        "https://lc-mhke0kuv.cn-n1.lcfile.com/65897f40be16cff0afc6.jpg",
    "isShow": true,
    "isSubscribe": false
  }
];

class Menu {
  String id;
  String name;
  String title;
  String icon;
  String background;
  bool isSubscribe;
  bool isShow;

  // TabMenu({
  //   @required this.id,
  //   @required this.name,
  //   @required this.title,
  //   @required this.icon,
  //   @required this.background,
  //   @required this.isSubscribe,
  //   @required this.isShow,
  // });

  //   factory MenuTab(Map jsonMap) =>
  //     Menu._internalFromJson(jsonMap);

  Menu._internalFromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        title = jsonMap['title'],
        icon = jsonMap['icon'],
        background = jsonMap['background'],
        isSubscribe = jsonMap['isSubscribe'],
        isShow = jsonMap['isShow'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'title': title,
        'icon': icon,
        'background': background,
        'isSubscribe': isSubscribe,
        'isShow': isShow
      };

  factory Menu.fromPrefsJson(Map jsonMap) => Menu._internalFromJson(jsonMap);
}
