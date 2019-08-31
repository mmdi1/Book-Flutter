import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/views/book/book_detail_screen.dart';
import 'package:thief_book_flutter/views/search/search_source_core.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';

class SearchSreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchSreenWidgetState();
  }
}

class SearchSreenWidgetState extends State<SearchSreenWidget> {
  String searchStr = "";
  var isflag = true;
  var isLoadingData = false;
  @override
  void initState() {
    super.initState();
  }

  List<Widget> bookItems = [];
  List<Book> listBooks = new List<Book>(); //列表要展示的数据
  //https://www.aixdzs.com/爱下电子书
  //初始数据
  fetchData(searchName) async {
    if (searchName != "") {
      listBooks = [];
      var books = await SearchSourceProcessing.aixdzsData(searchName);
      listBooks.addAll(books);
    }
  }

  searchBookName() async {
    var searchName = searchStr;
    RegExp exp = new RegExp(r"[\u4e00-\u9fa5]");
    var cnStr = exp.stringMatch(searchStr);
    if (cnStr != null) {
      searchName = Uri.encodeComponent(searchStr);
    }
    await fetchData(searchName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isflag) {
      fetchData("");
    }
    return new Scaffold(
      backgroundColor: Colors.white,
      body: FloatingSearchBar.builder(
        itemCount: listBooks.length - 1,
        itemBuilder: (BuildContext context, int index) {
          return _renderRow(context, index);
        },
        trailing: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            print("搜索内容：$searchStr");
            searchBookName();
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            print("点击返回");
          },
        ),
        onChanged: (String value) {
          searchStr = value;
        },
        onTap: () {
          print("点击了搜索框");
        },
        decoration: InputDecoration.collapsed(
          hintText: "Search...",
        ),
      ),
    );
  }

  _renderRow(BuildContext context, int index) {
    if (index < listBooks.length) {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.zero,
                child: Image(
                  width: 80,
                  image: CachedNetworkImageProvider(listBooks[index].imgUrl,
                      errorListener: () {
                    print("没有找到图片");
                  }),
                ),
                onPressed: () {
                  Navigator.push(context,
                      CustomRoute(widget: BookDetailScreen(listBooks[index]), type: 1));
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  prefix1.Text(listBooks[index].name),
                  prefix1.Text(listBooks[index].wordCount),
                  prefix1.Text(listBooks[index].author),
                  prefix1.Text("是否完结：" + listBooks[index].status),
                  prefix1.Text("介绍：" +
                      (listBooks[index].info.trim().length > 18
                          ? listBooks[index].info.trim().substring(0, 18) + ".."
                          : listBooks[index].info.trim())),
                ],
              ),
            ],
          ));
    }
  }
}
