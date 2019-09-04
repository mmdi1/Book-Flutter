import 'package:thief_book_flutter/common/utils/db_utils.dart';
import 'package:thief_book_flutter/models/book.dart';

class BookApi {
  static Future<Book> insertBook(Book book) async {
    var con = new LocalDb();
    var db = await con.getConn();
    /*将字符串转成json  返回的是键值对的形式*/
    book.id =
        await db.insert("books", new Map<String, dynamic>.from(book.toJson()));
    db.close();
    return book;
  }

  static Future<List<Book>> getBooks() async {
    var list = new List<Book>();
    var con = new LocalDb();
    var db = await con.getConn();
    List<Map> maps = await db.query("books", columns: [
      "id",
      "name",
      "status",
      "imgUrl",
      "importUrl",
      "author",
      "isCache",
      "catalogUrl",
      "isCacheIndex",
      "isCacheArticleId",
      "sourceType"
    ]);
    if (maps.length > 0) {
      maps.forEach((s) => {list.add(Book.fromJson(s))});
      return list;
    }
    db.close();
    return [];
  }

  static Future<int> update(Book book) async {
    var con = new LocalDb();
    var db = await con.getConn();
    var result = await db
        .update("books", book.toJson(), where: 'id = ?', whereArgs: [book.id]);
    db.close();
    return result;
  }
}
