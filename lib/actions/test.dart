// import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';

//    Dio dio = new Dio();
// //   Dio dio = new Dio();
// main() async {
//    var  response= dio.get("https://www.google.com/");
// print(requestRefresh());
// }
import 'dart:io';
import 'package:dio/dio.dart';

class DataResult {
  var data;
  bool result;

  DataResult(this.data, this.result);
}

main() async {
  // var dio = new Dio();
  // var response = await dio.get(Uri.encodeFull(
  //     'https://timeline-merger-ms.juejin.im/v1/get_entry_by_rank?src=web&uid=59120a711b69e6006865dd7b&device_id=1532136021731&token=eyJhY2Nlc3NfdG9rZW4iOiJWUmJ2dDR1RFRzY1JUZXFPIiwicmVmcmVzaF90b2tlbiI6IjBqdXhYSzA3dW9mSTJWUEEiLCJ0b2tlbl90eXBlIjoibWFjIiwiZXhwaXJlX2luIjoyNTkyMDAwfQ==&limit=20&category=5562b410e4b00c57d9b94a92&before='));

  // // print(response.statusCode);
  // // if (response == null) {
  // //   return new DataResult(null, false);
  // // }
  // // return new DataResult(response.data['d']['data'], true);
  // print(response.data['d']['entrylist']
  //     [response.data['d']['entrylist'].length - 1]['rankIndex']);
  // // Response response = await dio.get("https://pub.dartlang.org/packages/dio#-example-tab-");
  List list = [{'a': 1},{'b':2}];
  print(list.last)
;}
