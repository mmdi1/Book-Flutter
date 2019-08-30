import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:thief_book_flutter/common/config/config.dart';

class Request {
  static const String baseUrl = 'http://www.shuqi.com/';

  static Future<dynamic> get({String action, Map params}) async {
    return Request.mock(action: action, params: params);
  }

  static Future<dynamic> post({String action, Map params}) async {
    return Request.mock(action: action, params: params);
  }

  static Future<dynamic> mock({String action, Map params}) async {
    var responseStr = await rootBundle.loadString('assets/mocks/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson['data'];
  }

  static Future<dynamic> getArticleByPath(
      String path, String bookId, String articleId) async {
    var oldStr = path + '/' + bookId + "/article_" + articleId + ".json";
    var file = new File(oldStr);
    if (!file.existsSync()) {
      var id = int.parse(articleId);
      if (id > 0) {
        id--;
      }
      var responseStr = await rootBundle.loadString(
          path + '/' + bookId + "/article_" + id.toString() + ".json");
      var responseJson = json.decode(responseStr);
      return responseJson;
    }
    var responseStr = await rootBundle.loadString(oldStr);
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  // static Future<Dynamic> getArticle(String action) async{
  //   var responseStr = await rootBundle.loadString('assets/mocks/$action.json');
  //   var responseJson = json.decode(responseStr);
  //   return responseJson['data'];
  // }
}
