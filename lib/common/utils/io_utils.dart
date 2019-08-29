import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:thief_book_flutter/common/redux/progress_redux.dart';
import 'package:thief_book_flutter/common/server/articels_curd.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/book.dart';

class IoUtils {
  ///拆解txt文本到章节
  static splitTxtByStream(String bookName, String sourcePath, store) async {
    // var sql =
    //     "INSERT INTO books [(name, author, imgUrl,status,importUrl)] VALUES values(?,?,?,?,?);";
    var book = new Book(bookName, "作者", "imgUrl", 1, sourcePath);
    var bookApi = new BookApi();
    book = await bookApi.insertBook(book);
    print("bookid:${book.id}");
    // var bookId = await LocalDbCrud.rawInsert(
    //     sql, []);
    // 获取文档目录的路径
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dir = appDocDir.path;
    print(dir);
    //电子书文件大小：10.9 MB (11,431,697 字节)
    File file = new File(sourcePath);
    // assert(await file.exists() == true);
    print("源文件：${file.path}");
    //读取字节，并用Utf8解码
    print("\nRead Bytes:");
    var fileSize = file.lengthSync();
    var numBlockSize = (fileSize / 512).floor();
    var lastBlockSize = fileSize % 512;
    print("总长度:$fileSize,共:$numBlockSize块,剩余:$lastBlockSize块");
    var one = numBlockSize * 512;
    print("one:$one,two:${one + lastBlockSize}");
    var inputStream = file.openRead(); //0, 1024 * 128
    var lines = inputStream
        // 把内容用 utf-8 解码
        .transform(utf8.decoder)
        // 每次返回一行
        .transform(LineSplitter());
    RegExp exp = new RegExp(r"第\W+.*章");
    Article currAr = new Article(book.id, book.name, "", 0, 0, 0, 0);
    await LocalCrud.deleteAll();
    //章节索引
    var inedx = 0;
    DateTime time = new DateTime.now();
    print("开始时间:${time.hour}:${time.minute}:${time.second}");
    var content = "";
    await for (var line in lines) {
      Iterable<Match> matches = exp.allMatches(line);
      var lock = true;
      for (Match m in matches) {
        String match = m.group(0);
        print("章节-------$match");
        if (match.length < 15) {
          store.dispatch(new RefreshProgressDataAction("开始解析:" + match));
        }
        if (content.length > 0) {
          print("追加内容长度:${content.length}");
          currAr.content = content;
          await LocalCrud.appendArticel(currAr);
          content = "";
        }
        Article obj = new Article(book.id, line.substring(line.indexOf(match)),
            line, 0, inedx++, 0, 0);
        currAr = await LocalCrud.insertArticel(obj);
        lock = false;
      }
      if (lock) {
        content += line;
        // await LocalCrud.appendArticel(currAr);
      }
    }
    if (content != "") {
      print("最后一张的追加${content.length}");
      currAr.content = content;
      await LocalCrud.appendArticel(currAr);
    }
    store.dispatch(new RefreshProgressDataAction(""));
    DateTime etime = new DateTime.now();
    print("结束时间:${etime.hour}:${etime.minute}:${etime.second}");
  }
}
