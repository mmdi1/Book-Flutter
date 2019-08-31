import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Config {
  static String dbPath = "";
  static String filePath = "";
  static String spCacheBookId = "spCacheBookId_key";
  static String spCacheArticleId = "spCacheArticleId_key";
  static String spCachePageIndex = "spCachePageIndex_key";

  static String bookPath = "";

  /// 当前数据库版本 */
  static int currentDbVersion = 2;
  //根据数据库文件路径和数据库版本号创建数据库表
  static Future<String> getLocalDbPath() async {
    if (dbPath != "") {
      return dbPath;
    }
    var databasesPath = await getDatabasesPath();
    var path = databasesPath + "/book.db";
    dbPath = path;
    return path;
  }

  //获取文件路径
  static Future<String> getLocalFilePath(BuildContext context) async {
    if (filePath != "") {
      return filePath;
    }
    if (Theme.of(context).platform == TargetPlatform.android) {
      var path = await getExternalStorageDirectory();
      return path.path;
    }
    // 获取文档目录的路径
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dir = appDocDir.path;
    var path = dir + "/files";
    filePath = path;
    return path;
  }
}
