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
    await CacheNetBookCore.splitTxtByStream(this.widget.book, path, "");
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
      appBar: AppBar(
        title: Text(this.widget.book.name),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image(
                width: 80,
                image: CachedNetworkImageProvider(this.widget.book.imgUrl,
                    errorListener: () {
                  print("没有找到图片");
                }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(this.widget.book.name),
                  Text(this.widget.book.wordCount),
                  Text(this.widget.book.author),
                  Text("是否完结：" + this.widget.book.status),
                ],
              ),
            ],
          ),
          Text("介绍：" + (this.widget.book.info.trim())),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: new Text("缓存",
                    style: new TextStyle(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                onPressed: () {
                  print("缓存");
                  cacheNetBook();
                },
              ),
              RaisedButton(
                child: new Text("在线阅读",
                    style: new TextStyle(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                onPressed: () {
                  goToRederScreen();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
