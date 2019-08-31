import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/models/book.dart';

class BookDetailScreen extends StatefulWidget {
  Book book;
  BookDetailScreen(this.book);
  @override
  State<BookDetailScreen> createState() => BookDetailScreenWidget();
}

class BookDetailScreenWidget extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                },
              ),
              RaisedButton(
                child: new Text("在线阅读",
                    style: new TextStyle(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                onPressed: () {
                  print("在线阅读");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
