import 'dart:convert';
import 'package:html/parser.dart';
import 'package:thief_book_flutter/common/utils/http.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/chapter.dart';

class RedaerRequest {
  static Future<Article> getArticleByOline(
      {String linkUrl, String sourceType}) async {
    return await getAixdzsArticle(linkUrl);
  }

  static Future<List<Chapter>> getCotalogByOline(
      String linkUrl, String sourceType) async {
    return await getAixdzsCatalog(linkUrl);
  }

  static Future<List<Chapter>> getAixdzsCatalog(String linkUrl) async {
    final res = await Http.get(linkUrl);
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
  
  static Future<Article> getAixdzsArticle(String linkUrl) async {
    var catalog = linkUrl.substring(0, linkUrl.lastIndexOf("/"));
    final res = await Http.get(linkUrl);

    var str = utf8.decode(res);
    var html = parse(str);
    print("地址:${linkUrl}--$catalog-------------");
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
      preLink = linkUrl;
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
}
