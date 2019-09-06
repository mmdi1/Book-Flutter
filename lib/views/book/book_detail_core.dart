import 'package:flutter/material.dart';
import 'package:html/dom.dart' as prefix0;
import 'package:html/parser.dart';
import 'package:thief_book_flutter/common/utils/http.dart';

class BookDetailApi {
  static getScoreByQiDian({String bookName, String author}) async {
    var url =
        "https://www.qidian.com/search?kw=%E6%9C%80%E5%BC%BA%E5%BC%83%E5%B0%91";
    final res = await Http.getBody(url);
    var html = parse(res);
    var content = html.querySelector("#result-list");
    List<prefix0.Element> list = content.querySelectorAll("li");
    var detailUrl = "";
    list.forEach((li) {
      var bookName2 = li.querySelector("h4").text;
      var detailUril = "https:" +
          li
              .querySelector(".book-img-box")
              .querySelector("a")
              .attributes["href"];
      var author2 = li.querySelector(".author").querySelector(".name").text;
      bookName = "最强弃少";
      if (bookName == bookName2) {
        detailUrl = detailUril;
      }
    });
    var info = await getQiDianDetailInfo(detailUrl);
  }

  static getQiDianDetailInfo(String url) async {
    print("进入的url:$url");
    final res = await Http.getBody(url);
    var html = parse(res);
    var content = html.querySelector(".comment-wrap");
    print(content.innerHtml);
    var score1 = content.querySelector("#score1").text;
    var score2 = content.querySelector("#score2").text;
    var pep = content.querySelector("p").firstChild.text;
    print("分数:$score1,$score2,人数:$pep");
  }
}
