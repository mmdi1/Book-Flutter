import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/server/articels_curd.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/models/catalog.dart';
import 'package:thief_book_flutter/views/reader/reader_source_core.dart';

class CacheNetBookCore {
  static splitTxtByStream(Book book, String path, String srouceType) {
    splitAixdzsCore(book, path);
  }

  ///拆解txt文本到章节
  static splitAixdzsCore(Book book, String path) async {
    //bookName, "作者", "介绍", "字数", "imgUrl", "完结", sourcePath
    book.id = null;
    book = await BookApi.insertBook(book);
    Directory bf = new Directory(path + "/" + book.id.toString());
    if (!bf.existsSync()) {
      bf.createSync();
    }
    var lists = await RedaerRequest.getAixdzsCatalog(book.catalogUrl);
    Article currAr = new Article(
        novelId: book.id,
        title: book.name,
        content: "",
        price: 0,
        currentIndex: 0,
        nextArticleId: 0,
        preArticleId: 0);
    await LocalCrud.deleteAll();
    //章节索引
    var index = 0;
    DateTime time = new DateTime.now();
    debugPrint("开始时间:${time.hour}:${time.minute}:${time.second}");
    var listCatalogJson = '{"data":[';
    var lock = 0;
    for (var catalog in lists) {
      // if (lock == 3) {
      // await Future.delayed(const Duration(milliseconds: 2000), () {});
      //   lock = 0;
      // }
      // lock++;
      currAr.novelId = book.id;
      currAr.id = index;
      currAr.currentLink = catalog.linkUrl;
      currAr.nextArticleId = currAr.id + 1;
      currAr.preArticleId = (currAr.id - 1) <= 0 ? null : (currAr.id - 1);
      currAr.currentIndex = index;
      await ioWriteSync(currAr, catalog.linkUrl, path, book.id.toString());
      // store.dispatch(new RefreshProgressDataAction("开始解析:" + match));
      index++;
      print("-------------------------$index");
      var cJson = new Catalog(
          currAr.currentIndex, catalog.title, null, currAr.currentIndex);
      listCatalogJson += jsonEncode(cJson) + ",";
    }
    File cf = new File(path + "/" + book.id.toString() + "/catalog.json");
    print("写入地址:${cf.path}");
    cf.createSync();
    listCatalogJson =
        listCatalogJson.substring(0, listCatalogJson.lastIndexOf(",")) + "]}";
    cf.writeAsStringSync(listCatalogJson);
    // store.dispatch(new RefreshProgressDataAction(""));
    DateTime etime = new DateTime.now();
    debugPrint("结束时间:${etime.hour}:${etime.minute}:${etime.second}");
  }

  static Future ioWriteSync(
      Article currAr, String linkUrl, String path, String bookid) async {
    var reqData = await RedaerRequest.getAixdzsArticle(linkUrl);
    if (reqData == null) {
      print("为空写入--------------------------------------");
      //获取失败则写入数据库，等待再次缓存
      LocalCrud.insertArticel(currAr);
      return;
    }
    reqData.novelId = currAr.novelId;
    reqData.id = currAr.id;
    reqData.nextArticleId = currAr.nextArticleId;
    reqData.preArticleId = currAr.preArticleId;
    reqData.currentIndex = currAr.currentIndex;
    print("实际开始缓存章节:${reqData.title}");
    File af = new File(
        path + "/" + bookid + "/article_" + currAr.id.toString() + ".json");
    af.createSync();
    af.writeAsStringSync(jsonEncode(reqData));
  }
}
