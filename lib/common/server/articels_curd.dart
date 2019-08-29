import 'package:thief_book_flutter/common/utils/db_utils.dart';
import 'package:thief_book_flutter/models/article.dart';

class LocalCrud {
  // 插入一条书籍数据
  static Future<Article> insertArticel(Article articel) async {
    var con = new LocalDb();
    var db = await con.getConn();
    /*将字符串转成json  返回的是键值对的形式*/
    articel.id = await db.insert(
        "articels", new Map<String, dynamic>.from(articel.toJson()));
    await db.rawUpdate(
        "update articels set nextArticleId=?,preArticleId=? where id = ?",
        [articel.id + 1, articel.id - 1, articel.id]);
    db.close();
    return articel;
  }

  static Future<Article> getArticel(int id) async {
    var con = new LocalDb();
    var db = await con.getConn();
    List<Map> maps = await db.query("articels",
        columns: [
          "id",
          "title",
          "content",
          "novelId",
          "content",
          "price",
          "currentIndex",
          "nextArticleId",
          "preArticleId"
        ],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Article.fromJson(maps.first);
    }
    return null;
  }

  static Future<Article> getArticelByNovelId(int id) async {
    var con = new LocalDb();
    var db = await con.getConn();
    List<Map> maps = await db.query("articels",
        columns: [
          "id",
          "title",
          "content",
          "novelId",
          "content",
          "price",
          "currentIndex",
          "nextArticleId",
          "preArticleId"
        ],
        where: 'novelId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Article.fromJson(maps.first);
    }
    return null;
  }

  static Future<List<dynamic>> getArticelAllByNovelId(int id) async {
    var con = new LocalDb();
    var db = await con.getConn();
    List<Map> maps = await db.query("articels",
        columns: ["id", "title", "currentIndex"],
        where: 'novelId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return maps;
    }
    return null;
  }

  // 追加数据
  static Future<Article> appendArticel(Article articel) async {
    var con = new LocalDb();
    var db = await con.getConn();
    await db.rawInsert("update articels set content=content || ? where id=?;",
        [articel.content, articel.id]);
    db.close();
    return articel;
  }

  // 更新书籍信息
  static Future<int> updateArticel(Article articel) async {
    var con = new LocalDb();
    var db = await con.getConn();
    var result = await db.update(
        "articels", new Map<String, dynamic>.from(articel.toJson()),
        where: 'id = ?', whereArgs: [articel.id]);
    db.close();
    return result;
  }

  // 根据ID删除书籍信息
  static Future<int> deleteAll() async {
    var con = new LocalDb();
    var db = await con.getConn();
    var result = await db.delete("articels");
    db.close();
    return result;
  }
}
