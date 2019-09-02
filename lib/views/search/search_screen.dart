import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:thief_book_flutter/common/style/app_style.dart';
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
    isLoadingData = true;
    var searchName = searchStr;
    RegExp exp = new RegExp(r"[\u4e00-\u9fa5]");
    var cnStr = exp.stringMatch(searchStr);
    if (cnStr != null) {
      searchName = Uri.encodeComponent(searchStr);
    }
    await fetchData(searchName);
    setState(() {
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isflag) {
      fetchData("");
    }
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: FloatingSearchBar.builder(
          itemCount: listBooks.length - 1,
          itemBuilder: (BuildContext context, int index) {
            return isLoadingData
                ? Center(
                    child: Text("获取中..."),
                  )
                : _renderRow(context, index);
          },
          trailing: IconButton(
            padding: EdgeInsets.only(bottom: 10),
            icon: Icon(
              Icons.search,
              // color: AppColor.black,
            ),
            onPressed: () {
              print("搜索内容：$searchStr");
              searchBookName();
            },
          ),
          leading: IconButton(
            padding: EdgeInsets.only(bottom: 10, right: 20),
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: AppColor.black,
            ),
            onPressed: () {
              print("点击返回");
              Navigator.pop(context);
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
      ),
    );
  }

  Color hexToColor(String s) {
    // 如果传入的十六进制颜色值不符合要求，返回默认值
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _renderRow(BuildContext context, int index) {
    if (index < listBooks.length) {
      return Padding(
        padding: EdgeInsets.only(top: 10, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            contentView(index),
          ],
        ),
      );
    }
  }

  Widget contentView(int index) {
    return Container(
      //设置背景图片
      // decoration: new BoxDecoration(
      //   color: Colors.white,
      //   image: new DecorationImage(
      //     image: CachedNetworkImageProvider(
      //       listBooks[index].imgUrl,
      //     ),
      //     //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
      //     centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
      //   ),
      //   // border: new Border.all(width: 1.0, color: Colors.red),
      //   boxShadow: [
      //     BoxShadow(
      //       // color: hexToColor("#EFF0F1"),
      //       blurRadius: 1.0,
      //     ),
      //   ],
      //   borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
      // ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.zero,
            child: Image(
              width: 120,
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(listBooks[index].imgUrl,
                  errorListener: () {
                print("没有找到图片");
              }),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  CustomRoute(
                      widget: BookDetailScreen(listBooks[index]), type: 1));
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                ),
              ],
            ),
            child: textContentView(index),
          ),
        ],
      ),
    );
  }

  Widget textContentView(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        prefix1.Text(
          listBooks[index].name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Padding(padding: EdgeInsets.all(5)),
        // prefix1.Text(listBooks[index].wordCount),
        prefix1.Text(
          listBooks[index].author,
          style: TextStyle(color: AppColor.grey),
        ),
        Padding(padding: EdgeInsets.all(5)),
        prefix1.Text(
          "是否完结：" + listBooks[index].status,
          style: TextStyle(color: AppColor.grey),
        ),
        Padding(padding: EdgeInsets.all(5)),
        prefix1.Text(
          "来源：" + listBooks[index].sourceType,
          style: TextStyle(color: AppColor.grey),
        ),
        Row(
          children: <Widget>[
            RaisedButton(
              textTheme: ButtonTextTheme.normal,
              child: Text(
                '加入书桌',
              ),
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
            ),
            RaisedButton(
              child: Text(
                '开始阅读',
              ),
              onPressed: () {},
            ),
          ],
        ),

        // prefix1.Text(
        //   "介绍：" +
        //       (listBooks[index].info.trim().length > 1
        //           ? listBooks[index]
        //                   .info
        //                   .trim()
        //                   .substring(0, 1) +
        //               ".."
        //           : listBooks[index].info.trim()),
        //   overflow: TextOverflow.clip,
        //   maxLines: 1,
        // ),
      ],
    );
  }
}