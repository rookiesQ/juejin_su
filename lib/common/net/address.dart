const requestHeader = {
  'Accept': '*/*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'zh-CN,zh;q=0.9',
  'Connection': 'keep-alive',
  'Host': 'gold-tag-ms.juejin.im',
  'Origin': 'https://juejin.im',
  'Referer': 'https://juejin.im/timeline',
  'User-Agent':
      'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1',
  'X-Juejin-Client': '1532136021731',
  'X-Juejin-Src': 'web',
  'X-Juejin-Token':
      'eyJhY2Nlc3NfdG9rZW4iOiJWUmJ2dDR1RFRzY1JUZXFPIiwicmVmcmVzaF90b2tlbiI6IjBqdXhYSzA3dW9mSTJWUEEiLCJ0b2tlbl90eXBlIjoibWFjIiwiZXhwaXJlX2luIjoyNTkyMDAwfQ==',
  'X-Juejin-Uid': '59120a711b69e6006865dd7b'
};

///地址数据
class Address {
  static const String eventHost = 'https://event-storage-api-ms.juejin.im/';
  static const String timelineHost = 'https://timeline-merger-ms.juejin.im/';
  static const String postHost = 'https://post-storage-api-ms.juejin.im/';
  static const String msgHost = 'https://short-msg-ms.juejin.im/';
  // static const String updateUrl = 'https://www.pgyer.com/vj2B';

  static String commonRequest() =>
      '?src=${requestHeader['X-Juejin-Src']}&uid=${requestHeader['X-Juejin-Uid']}&device_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}';

  //文章分类列表
  static articleList(c, {l = 20, before = '', period = ''}) {
    return '${timelineHost}v1/get_entry_by_rank${commonRequest()}&limit=$l&category=$c&before=$before&period=$period';
  }

  ///文章详细
  static article(objectId) {
    return '${postHost}v1/getDetailData${commonRequest()}&type=entryView&postId=$objectId';
  }

  ///获取分类
  static category() {
    return "https://gold-tag-ms.juejin.im/v1/categories";
  }

  ///各个城市活动列表
  static eventList(
      {orderType = 'startTime', cityAlias = '', pageNum = 1, pageSize = 20}) {
    return "${eventHost}v2/getEventList${commonRequest()}&orderType=$orderType&cityAlias=$cityAlias&pageNum=$pageNum&pageSize=$pageSize'";
  }

  ///get topic
  static getTopicList() {
    return '${msgHost}v1/topicList/recommend${commonRequest()}';
  }

  ///get book
  static getBookList([pageNum = 1]) {
    return 'https://xiaoce-timeline-api-ms.juejin.im/v1/getListByLastTime${commonRequest()}&pageNum=$pageNum';
  }

  ///discovery list
  static getDiscovery([cate = 'all',  before = '', recomment = 1]) {
    return '${timelineHost}v1/get_entry_by_rank${commonRequest()}&limit=20&category=$cate&recomment=$recomment&before=$before';
  }

  ///get banner
  static getBanner() {
    return 'https://banner-storage-ms.juejin.im/v1/web/aanner?position=hero&platform=web&page=0&pageSize=20&src=web';
  }

  ///search
  static search(String query, [page = 0]) {
    return 'https://search-merger-ms.juejin.im/v1/search?query=$query&page=$page&raw_result=false&src=web&limit=20';
  }
}
