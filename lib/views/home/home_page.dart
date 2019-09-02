import 'dart:async';
import 'package:flutter/material.dart';

import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/style/app_style.dart';
import 'package:thief_book_flutter/common/utils/navigator_utils.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/views/book/bookshelf_item_view.dart';
import 'package:thief_book_flutter/views/home/home_banner.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageWidgetState();
  }
}

class HomePageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Widget> bookItems = [];
  //初始数据
  Future<void> fetchData() async {
    var bookApi = new BookApi();
    var books = await bookApi.getBooks();
    books.forEach((book) {
      bookItems.add(BookshelfItemView(book));
    });
    if (bookItems.length < 5) {
      bookItems.add(addItemView());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5)),
              Wrap(
                spacing: 23,
                children: bookItems,
              ),
            ],
          )),
    );
  }

  Widget addItemView() {
    var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
    return GestureDetector(
      onTap: () {
        if (bookItems.length > 5) {
          Toast.show("书架已达上限~");
          return;
        }
        AppNavigator.pushDownloadPage(context);
      },
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(width: 1.2, color: AppColor.black),
        ),
        width: width,
        height: width / 0.75,
        child: Center(
          child: Icon(Icons.add, color: AppColor.black, size: 32),
        ),
      ),
    );
  }
}
