import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/style/app_style.dart';
import 'package:thief_book_flutter/common/utils/navigator_utils.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/models/catalog.dart';
import 'package:thief_book_flutter/views/book/book_detail_screen.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';
import 'package:thief_book_flutter/views/reader/reader_source_core.dart';
import 'package:thief_book_flutter/views/search/search_source_core.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';
import 'package:thief_book_flutter/widgets/progress_dialog.dart';

class SearchSreenWidget extends StatefulWidget {
  final VoidCallback onSetState;
  SearchSreenWidget({this.onSetState});
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

  @override
  void dispose() {
    super.dispose();
    print('释放了搜索');
  }

  List<Widget> bookItems = [];
  List<Book> listBooks = new List<Book>(); //列表要展示的数据
  //https://www.aixdzs.com/爱下电子书
  //初始数据
  fetchData(searchName) async {
    if (searchName != "") {
      listBooks = [];
      var books = await SearchSourceProcessing.searchAllNetWork(searchName);
      print("-----------搜索的长度：${books.length}");
      listBooks.addAll(books);
    }
  }

  searchBookName() async {
    isLoadingData = true;
    setState(() {});
    var searchName = searchStr;
    RegExp exp = new RegExp(r"[\u4e00-\u9fa5]");
    var cnStr = exp.stringMatch(searchStr);
    if (cnStr != null) {
      searchName = Uri.encodeComponent(searchStr);
    }
    await fetchData(searchName);
    // await Future.delayed(const Duration(milliseconds: 6000), () {});
    setState(() {
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isflag) {
      fetchData("");
    }
    return new StoreBuilder<ReduxState>(builder: (context, store) {
      return new Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(top: 15),
          child: FloatingSearchBar.builder(
            itemCount: listBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return _renderRow(context, index);
            },
            trailing: isLoadingData
                ? Padding(
                    child: Image.asset(
                      'assets/images/search_loading.gif',
                      height: 20,
                    ),
                    padding: EdgeInsets.only(bottom: 10, right: 10),
                  )
                : IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.only(bottom: 10),
                    icon: Icon(
                      Icons.search,
                      // color: AppColor.black,
                    ),
                    onPressed: () {
                      if (searchStr.trim() == "") {
                        Toast.show("请输入书名搜索");
                        return;
                      }
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
                this.widget.onSetState();
                // print("点击返回");
                // AppNavigator.pushHome(context, store);
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
              hintText: "输入书名、作者...",
            ),
          ),
        ),
      );
    });
  }

  _renderRow(BuildContext context, int index) {
    if (index < listBooks.length) {
      return Padding(
        padding: EdgeInsets.only(top: 10, left: 23),
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
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.zero,
            child:
                //设置背景图片
                Container(
              width: 120,
              height: 158,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: CachedNetworkImageProvider(
                    listBooks[index].imgUrl,
                    errorListener: () {
                      print("图片加载错误---$index");
                    },
                  ),
                ),
                // border: new Border.all(width: 1, color: AppColor.black),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black,
                    blurRadius: 1.0,
                  ),
                ],
                // borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
              ),
            ),
            // Image(
            //   width: 120,
            //   fit: BoxFit.cover,
            //   image: CachedNetworkImageProvider(listBooks[index].imgUrl,
            //       errorListener: () {
            //     print("没有找到图片");
            //   }),
            // ),
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
              color: Colors.white,
              child: Text(
                '加入书桌',
              ),
              onPressed: () {
                print("加入书桌");
                addBookshelfApi(index);
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
                goToRederScreen(index);
              },
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

  //
  goToRederScreen(int index) async {
    if (this.listBooks[index].sourceType == "aixdzs") {
      Navigator.of(context).push(CustomRoute(
          widget: new ReaderScene(
            isOlineRedaer: true,
            catalogUrl: this.listBooks[index].catalogUrl,
            sourceType: this.listBooks[index].sourceType,
          ),
          type: 1));
      // Navigator.of(context).pushAndRemoveUntil(
      //     new MaterialPageRoute(
      //         builder: (context) => new ReaderScene(
      //             isOlineRedaer: true,
      //             fisrtSourceLink: this.widget.book.catalogUrl + "p1.html")),
      //     (route) => route == null);
    }
  }

  addBookshelfApi(index) async {
    ProgressDialog.showLoadingDialog(context, "正在加入书桌...");
    var book = this.listBooks[index];
    book.isCache = 0;
    book = await BookApi.insertBook(book);
    var listCatalog =
        await RedaerRequest.getCotalogByOline(book.catalogUrl, book.sourceType);
    var listCatalogJson = '{"data":[';
    var i = 0;
    listCatalog.forEach((s) {
      var cJson = new Catalog(s.id, s.title, s.linkUrl, i);
      listCatalogJson += jsonEncode(cJson) + ",";
    });
    var path = await Config.getLocalFilePath(context);
    Directory bf = new Directory(path + "/" + book.id.toString());
    if (!bf.existsSync()) {
      bf.createSync();
    }
    File cf = new File(path + "/" + book.id.toString() + "/catalog.json");
    print("写入地址:${cf.path}");
    cf.createSync();
    listCatalogJson =
        listCatalogJson.substring(0, listCatalogJson.lastIndexOf(",")) + "]}";
    cf.writeAsStringSync(listCatalogJson);
    print("============${book.toJson()}");
    if (book.id != null && book.id > 0) {
      Toast.show("已加入书桌");
    } else {
      Toast.show("加入失败");
    }
    Navigator.pop(context);
  }
}
