import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/models/catalog.dart';
import 'package:thief_book_flutter/views/book/book_detail_core.dart';
import 'package:thief_book_flutter/views/book/cache_book_core.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';
import 'package:thief_book_flutter/views/reader/reader_source_core.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';
import 'package:thief_book_flutter/widgets/progress_dialog.dart';

class BookDetailScreen extends StatefulWidget {
  Book book;
  final int type; //0是首页进入 1是搜索进入
  BookDetailScreen({this.book, this.type});
  @override
  State<BookDetailScreen> createState() => BookDetailScreenWidget();
}

class BookDetailScreenWidget extends State<BookDetailScreen> {
  var addBook = false;
  @override
  void initState() {
    // RedaerRequest.getAixdzsArticle("/168/168363/p1.html");
    super.initState();
    print(this.widget.type);
    initData();
  }

  //
  @override
  void dispose() {
    if (this.widget.type == 1) {
      print("释放了....");
      // deleteBookFunc();
    }
    super.dispose();
  }

  initData() async {
    if (this.widget.type == 1) {
      //从搜索列表进来才缓存
      addBookshelfApi();
    }

    // BookDetailApi.getScoreByQiDian();
  }

  //缓存
  cacheNetBook() async {
    // 获取存储路径
    var path = await Config.getLocalFilePath(context);
    Config.isLodingDown++;
    await CacheNetBookCore.splitTxtByStream(this.widget.book, path);
  }

  addBookshelfApi() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    var path = await Config.getLocalFilePath(context);
    // ProgressDialog.showLoadingDialog(context, "解析目录中...");
    var book = this.widget.book;
    var exBook = await BookApi.getBookByName(book.name, book.author);
    if (exBook != null) {
      print("已有当前书籍:${exBook.toJson()}");
      book = exBook;
    }
    print("+=============================${book.toJson()}");
    Directory existsBook =
        new Directory(path + "/" + book.id.toString());
    if (existsBook.existsSync()) {
      setState(() {});
      return;
    }

    var listCatalog =
        await RedaerRequest.getCotalogByOline(book.catalogUrl, book.sourceType);
    var listCatalogJson = '{"data":[';
    var i = 0;
    listCatalog.forEach((s) {
      var cJson = new Catalog(s.id, s.title, s.linkUrl, i);
      i++;
      listCatalogJson += jsonEncode(cJson) + ",";
    });
    book.catalogNum = i; //记录章节总数
    book.id = null;
    book.isCache = 1;
    book.isCacheIndex = 0;
    book.isCacheArticleId = 0;
    print("总章节数:$i,,,,,${book.toJson()}");
    book = await BookApi.insertBook(book);
    print("加入书桌的地址:${path + "/" + book.id.toString()}");
    Directory bfb = new Directory(path + "/" + book.id.toString());
    bfb.createSync(recursive: true);
    File cf = new File(path + "/" + book.id.toString() + "/catalog.json");
    print("写入地址:${cf.path}");
    cf.createSync(recursive: true);
    listCatalogJson =
        listCatalogJson.substring(0, listCatalogJson.lastIndexOf(",")) + "]}";
    cf.writeAsStringSync(listCatalogJson);
    print("============${book.toJson()}");
    if (book.id != null && book.id > 0) {
      Toast.show("已加入书桌");
      // 获取存储路径
      Config.isLodingDown++;
      CacheNetBookCore.splitTxtByStream(book, path);
    } else {
      Toast.show("加入失败，请检查网络");
    }
    // Navigator.pop(context);
  }

  //
  goToRederScreen() async {
    if (this.widget.book.sourceType == "aixdzs") {
      Navigator.of(context).push(CustomRoute(
          widget: new ReaderScene(
              isOlineRedaer: true, catalogUrl: this.widget.book.catalogUrl),
          type: 1));
      // Navigator.of(context).pushAndRemoveUntil(
      //     new MaterialPageRoute(
      //         builder: (context) => new ReaderScene(
      //             isOlineRedaer: true,
      //             fisrtSourceLink: this.widget.book.catalogUrl + "p1.html")),
      //     (route) => route == null);
    }
  }

  Widget buildTopView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //     style: BorderStyle.solid, width: 3, color: Colors.black)
        // border: BorderDirectional(
        //   start: new BorderSide(color: Colors.black, width:3 ),
        //   top: new BorderSide(color: Colors.black, width: 3),
        //   end: new BorderSide(color: Colors.black, width: 3),
        // ),
        image: new DecorationImage(
          fit: BoxFit.fitHeight,
          image: CachedNetworkImageProvider(
            "https://img.51miz.com/Element/00/81/16/70/d76fb54b_E811670_5867bd35.jpg!/quality/90/unsharp/true/compress/true/format/jpg",
            errorListener: () {},
          ),
        ),
      ),
      height: 200,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Text(this.widget.book.name,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
              SizedBox(height: 8),
              Text(this.widget.book.author),
              SizedBox(height: 8),
              Text(this.widget.book.status +
                  "   " +
                  (this.widget.book.catalogNum != null
                      ? ("共" + this.widget.book.catalogNum.toString() + "章")
                      : "" + "  ") +
                  this.widget.book.wordCount.substring(3)),
            ],
          ),
          Container(
            height: 85,
            margin: EdgeInsets.only(top: 35, left: 50),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Colors.black, style: BorderStyle.solid),
            ),
          ),
          SizedBox(width: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                "蒲牢评分",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text("暂无",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text("★★★★★", style: TextStyle(color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNetScoreView() {
    return Container(
      decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(
          //         style: BorderStyle.solid, width: 3, color: Colors.black)),
          border: BorderDirectional(
              bottom: new BorderSide(color: Colors.grey[100], width: 2),
              top: new BorderSide(color: Colors.grey[100], width: 2))),
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Row(children: <Widget>[
          Text("豆瓣评分",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18))
        ]),
        SizedBox(height: 8),
        Row(children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            Text("9.8",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text("★���������★★★",
                style: TextStyle(color: Colors.orange, fontSize: 14)),
          ]),
          SizedBox(width: 100),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            buildRowStarView(5, 78),
            buildRowStarView(4, 6),
            buildRowStarView(3, 10),
            buildRowStarView(2, 4),
            buildRowStarView(1, 2),
            SizedBox(height: 8),
          ]),
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("123216评分", style: TextStyle(fontSize: 10)),
                margin: EdgeInsets.only(right: 40),
              ),
            ])
      ]),
    );
  }

  Widget buildRowStarView(int n, double rate) {
    //rate 星级占比
    var txt = "";
    for (var i = 0; i < n; i++) {
      txt += "★";
    }
    double heightAndFontSize = 9;
    return Row(
      children: <Widget>[
        Text(txt,
            style:
                TextStyle(color: Colors.orange, fontSize: heightAndFontSize)),
        SizedBox(width: 2),
        Container(
          height: heightAndFontSize,
          margin: EdgeInsets.all(0.5),
          width: 120,
          color: Colors.grey[100],
          child: Container(
            margin: EdgeInsets.only(right: (120 - (rate * 1.2))),
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 2),
        SizedBox(
          width: 30,
          child: Text(rate.toString() + "%",
              style: TextStyle(fontSize: heightAndFontSize)),
        )
      ],
    );
  }

  Widget buildInfoView() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "介绍：" + this.widget.book.info.trim(),
            maxLines: 4,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          SizedBox(height: 30),
          Text("已缓存1273章  已读至：第232章",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  //加入书桌按钮
  Widget buildBtnRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.white,
          child: Text(
            '返回',
          ),
          onPressed: () {
            print("返回");
            deleteBookFunc();
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          color: Colors.white,
          child: Text(
            '加入书桌',
          ),
          onPressed: () {
            print("加入书桌");
            addBook = true;
            addBookshelfApi();
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text(
            '开始阅读',
          ),
          onPressed: () {
            goToRederScreen();
          },
        ),
      ],
    );
  }

  //如果没有加入书桌，则清除下载记录
  deleteBookFunc() async {
    if (this.widget.type != 1) {
      return;
    }
    if (addBook) {
      return;
    }
    print("进入清除下载记录");
    Config.isLodingDown = 0;
    BookApi.delete(this.widget.book.id);
    var path = await Config.getLocalFilePath(context);
    Directory bfb = new Directory(path + "/" + this.widget.book.id.toString());
    if (bfb.existsSync()) {
      bfb.deleteSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTopView(),
          buildInfoView(),
          // buildNetScoreView(),
          this.widget.type == 1 ? buildBtnRow() : SizedBox(),
          this.widget.type == 1
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.only(left: 10, top: 20),
                  width: 80,
                  child: RaisedButton(
                    color: Colors.white,
                    child: Text(
                      '返回',
                    ),
                    onPressed: () {
                      print("返回");
                      deleteBookFunc();
                      Navigator.pop(context);
                    },
                  ),
                )

          // Text("介绍：" + (this.widget.book.info.trim())),
          // ButtonBar(
          //   children: <Widget>[
          //     RaisedButton(
          //       child: new Text("缓存",
          //           style: new TextStyle(fontSize: 20),
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis),
          //       onPressed: () {
          //         print("缓存");
          //         cacheNetBook();
          //       },
          //     ),
          //     RaisedButton(
          //       child: new Text("在线阅读",
          //           style: new TextStyle(fontSize: 20),
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis),
          //       onPressed: () {
          //         goToRederScreen();
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
