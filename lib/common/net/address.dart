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
  static const String eventHost = "https://event-storage-api-ms.juejin.im/";
  static const String timelineHost = "https://timeline-merger-ms.juejin.im/";
  // static const String downloadUrl = 'https://www.pgyer.com/GSYGithubApp';
  // static const String graphicHost = 'https://ghchart.rshah.org/';
  // static const String updateUrl = 'https://www.pgyer.com/vj2B';

  static homeCategory(c, {l = 20, before = ''}) {
    return '${timelineHost}v1/get_entry_by_rank?src=${requestHeader['X-Juejin-Src']}&uid=${requestHeader['X-Juejin-Uid']}&device_id=${requestHeader['X-Juejin-Client']}&token=${requestHeader['X-Juejin-Token']}&limit=$l&category=$c&before=$before';
  }

  ///获取分类
  static category() {
    return "https://gold-tag-ms.juejin.im/v1/categories";
  }

  ///各个城市活动列表
  static eventList(
      {orderType = 'startTime', cityAlias = '', pageNum = 1, pageSize = 20}) {
    return "${eventHost}v2/getEventList?uid=&client_id=&token=&src=${requestHeader['X-Juejin-Src']}&orderType=$orderType&cityAlias=$cityAlias&pageNum=$pageNum&pageSize=$pageSize'";
  }
}
