import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/views/book/cache_book_core.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';

class BookDetailScreen extends StatefulWidget {
  Book book;
  BookDetailScreen(this.book);
  @override
  State<BookDetailScreen> createState() => BookDetailScreenWidget();
}

class BookDetailScreenWidget extends State<BookDetailScreen> {
  @override
  void initState() {
    // RedaerRequest.getAixdzsArticle("/168/168363/p1.html");

    super.initState();
  }

  //
  @override
  void dispose() {
    super.dispose();
  }

  cacheNetBook() async {
    // 获取存储路径
    var path = await Config.getLocalFilePath(context);
    await CacheNetBookCore.splitTxtByStream(this.widget.book, path);
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

  @override
  Widget build(BuildContext context) {
    print(this.widget.book.toJson());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          buildTopView(),
          buildNetScoreView(),
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
                  "共2918章" +
                  "  " +
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
              Text("97.8",
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
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     border: Border.all(
      //         style: BorderStyle.solid, width: 3, color: Colors.black)),
      // border: BorderDirectional(
      //     bottom: new BorderSide(color: Colors.black, width: 2))),
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
            Text("★★★★★", style: TextStyle(color: Colors.orange, fontSize: 14)),
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
}
