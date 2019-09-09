// 获取数据库文件的存储路径
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:thief_book_flutter/common/utils/sp_uitls.dart';
import 'package:thief_book_flutter/common/config/config.dart';

class DbUtils {
  static Future<void> initDbTabel() async {
    // List<int> bytes = new  File(
    //         "/Users/joucks/Library/Developer/CoreSimulator/Devices/FDD6A480-A41B-4D73-BFA0-F20A30ECC134/data/Containers/Data/Application/5530E1F9-3885-44E7-AF8B-268F87BFC113/Documents/files/58741txt.zip")
    //     .readAsBytesSync();
    //     print(bytes);
    // Archive archive = ZipDecoder().decodeBytes(bytes);
    // print("--------------------111");
    // // Extract the contents of the Zip archive to disk.
    // for (ArchiveFile file in archive) {
    //   String filename = file.name;
    //   print("---------$filename");
    //   if (file.isFile) {
    //     List<int> data = file.content;
    //     File(
    //         '/Users/joucks/Library/Developer/CoreSimulator/Devices/FDD6A480-A41B-4D73-BFA0-F20A30ECC134/data/Containers/Data/Application/5530E1F9-3885-44E7-AF8B-268F87BFC113/Documents/files/' +
    //             filename)
    //       ..createSync(recursive: true)
    //       ..writeAsBytesSync(data);
    //   } else {
    //     Directory(
    //         '/Users/joucks/Library/Developer/CoreSimulator/Devices/FDD6A480-A41B-4D73-BFA0-F20A30ECC134/data/Containers/Data/Application/5530E1F9-3885-44E7-AF8B-268F87BFC113/Documents/files/' +
    //             filename)
    //       ..create(recursive: true);
    //   }
    // }
    print("初始数据库");
    var dbPath = await Config.getLocalDbPath();
    print("dbPath:$dbPath");
    var exists = await SpUtils.getBool("initDbKey");
    if (exists == true) {
      print("已存在数据库");
      //已存在数据库
      return;
    }
    var fileDb = new File(dbPath);
    var flag = await fileDb.exists();
    if (flag) {
      print("删除数据库");
      await fileDb.delete();
      await Future.delayed(const Duration(milliseconds: 1000), () {});
    }
    var db = await openDatabase(dbPath, version: Config.currentDbVersion,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //数据库升级,只回调一次
      print("数据库需要升级！旧版：$oldVersion,新版：$newVersion");
    }, onCreate: (Database db, int version) async {
      print("初始数据库进来了------------");
      await db.execute('''
          CREATE TABLE books (
            id INTEGER PRIMARY KEY,
            name TEXT,
            author TEXT,
            imgUrl TEXT,
            status INTEGER,
            importUrl TEXT,
            info TEXT,
            wordCount TEXT,
            catalogUrl TEXT,
            sourceAddress TEXT,
            sourceType TEXT,
            isCache INTEGER,
            isCacheIndex INTEGER,
            isCacheArticleId INTEGER,
            catalogNum INTEGER,
            cacheToUrl  TEXT,
            createdAt TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE articels (
            id INTEGER PRIMARY KEY,
             novelId INTEGER,
             title TEXT,
             content BLOB,
             currentIndex INTEGER,
             price INTEGER,
             nextArticleId INTEGER,
             preArticleId INTEGER,
             sourceType TEXT,
             currentLink TEXT,
             preLink TEXT,
             nextLink TEXT
          )
          ''');
      await db.close();
    });
    print("完成初始数据库");
    await SpUtils.setBool("initDbKey", true);
    db.close();
  }
}

class LocalDb {
  Future<Database> getConn() async {
    var dbPath = await Config.getLocalDbPath();
    var db = await openDatabase(dbPath, version: Config.currentDbVersion);
    return db;
  }

  Future<int> rawInsert(String sql, List<dynamic> params) async {
    var db = await getConn();
    var lastId = await db.rawInsert(sql, params);
    db.close();
    return lastId;
  }

  Future<int> rawUpdate(String sql, List<dynamic> params) async {
    var db = await getConn();
    var lastId = await db.rawUpdate(sql, params);
    db.close();
    return lastId;
  }

  Future<int> rawDelete(String sql, List<dynamic> params) async {
    var db = await getConn();
    var lastId = await db.rawDelete(sql, params);
    db.close();
    return lastId;
  }

  Future<List<Map<String, dynamic>>> rawQuery(
      String sql, List<dynamic> params) async {
    var db = await getConn();
    var obj = await db.rawQuery(sql, params);
    db.close();
    return obj;
  }
}
