import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/server/articels_curd.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/models/catalog.dart';
import 'package:thief_book_flutter/views/reader/reader_source_core.dart';

class CacheNetBookCore {
  static splitTxtByStream(Book book, String path) {
    if (Config.isLodingDown > 1) {
      Config.isLodingDown--;
      Toast.show("已有下载进程");
      return;
    }
    splitAixdzsCore(book, path);
  }

  ///拆解txt文本到章节
  static splitAixdzsCore(Book book, String path) async {
    //bookName, "作者", "介绍", "字数", "imgUrl", "完结", sourcePath
    var responseStr = await rootBundle
        .loadString(path + "/" + book.id.toString() + "/catalog.json");
    var jsonStr = json.decode(responseStr);
    List<Catalog> catalogs = [];
    List<dynamic> chaptersResponse = jsonStr["data"];
    chaptersResponse.sublist(book.isCacheIndex).forEach((data) {
      catalogs.add(Catalog.fromJson(data));
    });
    Article currAr = new Article(
        novelId: book.id,
        title: book.name,
        content: "",
        price: 0,
        currentIndex: 0,
        nextArticleId: 0,
        preArticleId: 0);
    // await LocalCrud.deleteAll();
    //章节索引  如果是续存则从缓存的地方开始
    var index = book.isCacheArticleId;
    DateTime time = new DateTime.now();
    var lock = 0;
    debugPrint("开始时间:${time.hour}:${time.minute}:${time.second}");
    for (var catalog in catalogs) {
      if (Config.isLodingDown == 0) {
        //如果暂停则直接返回
        return;
      }
      currAr.novelId = book.id;
      currAr.id = index;
      currAr.currentLink = catalog.linkUrl;
      currAr.nextArticleId = index + 1;
      currAr.preArticleId = (index - 1) < 0 ? null : (currAr.id - 1);
      currAr.currentIndex = index;
      var isOk =
          await ioWriteSync(currAr, catalog.linkUrl, path, book.id.toString());
      if (isOk) {
        book.isCacheArticleId = index;
        book.isCacheIndex = index;
        if (index == chaptersResponse.length - 1) {
          //如果缓存的章节到最后一章，则完成当前正本缓存
          book.isCache = 2;
        }
        print("更新书籍信息:${book.toJson()}");
        await BookApi.update(book);
      } else {
        print("可能因网速原因终止缓存,页面地址:${catalog.linkUrl}");
        //等待30秒继续缓存.如果一次缓存中出现两次错误，则停止
        lock++;
        await Future.delayed(const Duration(seconds: 30), () {});
        if (lock == 2) {
          return;
        }
      }

      // store.dispatch(new RefreshProgressDataAction("开始解析:" + match));
      index++;
      print("-------------------------$index");
    }
    // store.dispatch(new RefreshProgressDataAction(""));
    DateTime etime = new DateTime.now();
    debugPrint("结束时间:${etime.hour}:${etime.minute}:${etime.second}");
  }

  static Future<bool> ioWriteSync(
      Article currAr, String linkUrl, String path, String bookid) async {
    var reqData = await RedaerRequest.getAixdzsArticle(linkUrl);
    if (reqData == null) {
      print("为空写入--------------------------------------");
      //获取失败则写入数据库，等待再次缓存
      LocalCrud.insertArticel(currAr);
      return false;
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
    return true;
  }
}
