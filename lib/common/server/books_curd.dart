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

  static Future<Book> getBook(int id) async {
    var con = new LocalDb();
    var db = await con.getConn();
    List<Map> maps = await db.query("books",
        columns: [
          "id",
          "name",
          "status",
          "imgUrl",
          "info",
          "wordCount",
          "importUrl",
          "author",
          "isCache",
          "catalogUrl",
          "isCacheIndex",
          "isCacheArticleId",
          "sourceType"
        ],
        where: "id = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Book.fromJson(maps.first);
    }
    db.close();
    return null;
  }

  static Future<Book> getBookByAnyIsCache() async {
    var con = new LocalDb();
    var db = await con.getConn();
    List<Map> maps = await db.query("books",
        columns: [
          "id",
          "name",
          "status",
          "imgUrl",
          "info",
          "wordCount",
          "importUrl",
          "author",
          "isCache",
          "catalogUrl",
          "isCacheIndex",
          "isCacheArticleId",
          "sourceType"
        ],
        where: "isCache = ?",
        whereArgs: [1]);
    if (maps.length > 0) {
      return Book.fromJson(maps.first);
    }
    db.close();
    return null;
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
      "info",
      "wordCount",
      "importUrl",
      "author",
      "isCache",
      "catalogUrl",
      "isCacheIndex",
      "isCacheArticleId",
      "catalogNum",
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
  // 根据ID删除书籍信息
  static Future<int> delete(int id) async {
    var con = new LocalDb();
    var db = await con.getConn();
    return await db.delete("books", where: 'id = ?', whereArgs: [id]);
  }
}
