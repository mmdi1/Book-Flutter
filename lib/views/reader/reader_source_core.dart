import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart';
import 'package:thief_book_flutter/common/utils/http.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/chapter.dart';

class RedaerRequest {
  //在线获取章节
  static Future<Article> getArticleByOline(
      {String linkUrl, String sourceType}) async {
    print("源类型:$sourceType");
    if (sourceType == "aixdzs") {
      return await getAixdzsArticle(linkUrl);
    }
    return await getXbiqugeArticle(linkUrl);
  }

  //在线获取目录
  static Future<List<Chapter>> getCotalogByOline(
      String linkUrl, String sourceType) async {
    print("源类型目录:$sourceType");
    if (sourceType == "aixdzs") {
      return await getAixdzsCatalog(linkUrl);
    }
    return await getXbiqugeCatalog(linkUrl);
  }

  //爱下电子书目录
  static Future<List<Chapter>> getAixdzsCatalog(String linkUrl) async {
    final res = await Http.get(linkUrl);
    if (res == null) {
      return [];
    }
    var str = utf8.decode(res);
    var html = parse(str);
    var listLi = html.querySelectorAll(".chapter");
    var catalogs = new List<Chapter>();
    var index = 0;
    print("---------$linkUrl");
    listLi.forEach((li) {
      var catalog = new Chapter(
          id: 0,
          title: li.firstChild.text,
          linkUrl: linkUrl + li.firstChild.attributes['href'],
          index: index);
      index++;
      catalogs.add(catalog);
    });
    return catalogs;
  }

  //爱下电子书章节
  static Future<Article> getAixdzsArticle(String linkUrl) async {
    var catalog = linkUrl.substring(0, linkUrl.lastIndexOf("/"));
    final res = await Http.get(linkUrl);
    if (res == null) {
      return null;
    }
    var str = utf8.decode(res);
    var html = parse(str);
    var body = html.querySelector("body");
    var title = body.querySelector("h1").text;
    var nextLink = catalog +
        "/" +
        body.querySelector(".link").children[2].attributes["href"];
    var preLink = catalog +
        "/" +
        body.querySelector(".link").children[0].attributes["href"];
    var content = body.querySelector(".content");
    var listP = content.querySelectorAll("p");
    var contentTxt = "";
    listP.forEach((p) {
      contentTxt += "\n   " + p.text;
    });
    if (preLink.indexOf(".html") < 0) {
      preLink = null;
    }
    var article = new Article(
        novelId: -1,
        title: title,
        content: contentTxt,
        nextLink: nextLink,
        preLink: preLink,
        currentLink: linkUrl);
    print("解析==============");
    print(article.title);
    return article;
  }

  //新笔趣阁目录
  static Future<List<Chapter>> getXbiqugeCatalog(String linkUrl) async {
    final res = await Http.get(linkUrl);
    if (res == null) {
      return [];
    }
    var str = utf8.decode(res);
    var html = parse(str);
    var main = html.querySelector("#list");
    var listA = main.querySelectorAll("a");
    var catalogs = new List<Chapter>();
    var index = 0;
    print("---------$linkUrl");
    listA.forEach((a) {
      var catalog = new Chapter(
          id: 0,
          title: a.text,
          linkUrl: linkUrl.substring(0, linkUrl.indexOf("com") + 4) +
              a.attributes['href'].substring(1),
          index: index);
      index++;
      catalogs.add(catalog);
    });
    return catalogs;
  }

  //新笔趣阁章节
  static Future<Article> getXbiqugeArticle(String linkUrl) async {
    var catalog = linkUrl.substring(0, linkUrl.lastIndexOf("com") + 3);
    final res = await Http.get(linkUrl);
    if (res == null) {
      return null;
    }
    var str = utf8.decode(res);
    var html = parse(str);
    var body = html.querySelector(".box_con");
    var title = body.querySelector("h1").text;
    var nextLink = catalog +
        "/" +
        body.querySelector(".bottem1").children[2].attributes["href"];
    var preLink = catalog +
        "/" +
        body.querySelector(".bottem1").children[0].attributes["href"];

    var content = body.querySelector("#content");
    var contentTxt = content.text;
    if (preLink.indexOf(".html") < 0) {
      preLink = null;
    }
    var file = new File(
        "/Users/joucks/Library/Developer/CoreSimulator/Devices/FDD6A480-A41B-4D73-BFA0-F20A30ECC134/data/Containers/Data/Application/4B57B339-689E-4738-B764-4C973447D97F/Documents/test.txt");
    file.createSync();
    contentTxt = contentTxt.replaceAll('。', '。\n   ');
    file.writeAsStringSync(contentTxt);
    var article = new Article(
        novelId: -1,
        title: title,
        content: contentTxt,
        nextLink: nextLink,
        preLink: preLink,
        currentLink: linkUrl);
    print(article.title);
    return article;
  }
}
