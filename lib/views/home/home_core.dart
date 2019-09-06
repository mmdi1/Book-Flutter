import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/utils/sp_uitls.dart';
import 'package:thief_book_flutter/views/book/cache_book_core.dart';

class HomeApi {
  static cacheBook(String path) async {
    var bookid = await SpUtils.getInt(Config.spCacheBookId); //获取上次阅读的bookid
    var book = await BookApi.getBook(bookid);
    if (book != null && book.isCache == 1) {
      print("进入自动续存名称:${book.name}");
      CacheNetBookCore.splitTxtByStream(book, path);
      return;
    }
    //如果上面在读小说已经缓存完毕，则自动抓取未全本缓存的其他小说
    var book2 = await BookApi.getBookByAnyIsCache();
    if (book2 != null && book2.isCache == 1) {
      print("进入自动续存名称:${book.name}");
      CacheNetBookCore.splitTxtByStream(book, path);
      return;
    }
  }
}
