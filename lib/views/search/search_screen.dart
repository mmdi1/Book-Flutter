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
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/models/catalog.dart';
import 'package:thief_book_flutter/views/book/book_detail_screen.dart';
import 'package:thief_book_flutter/views/book/cache_book_core.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';
import 'package:thief_book_flutter/views/reader/reader_source_core.dart';
import 'package:thief_book_flutter/views/search/search_source_core.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';
import 'package:thief_book_flutter/widgets/progress_dialog.dart';

class SearchSreenWidget extends StatefulWidget {
  final VoidCallback onSetState;
  SearchSreenWidget({this.onSetState});
  @override
  SearchSreenWidgetState createState() => SearchSreenWidgetState();
}

class SearchSreenWidgetState extends State<SearchSreenWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  String searchStr = "";
  var isLoadingData = false;
  //动画控制器
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    //AnimationController是一个特殊的Animation对象，在屏幕刷新的每一帧，就会生成一个新的值，
    // 默认情况下，AnimationController在给定的时间段内会线性的生成从0.0到1.0的数字
    //用来控制动画的开始与结束以及设置动画的监听
    //vsync参数，存在vsync时会防止屏幕外动画（动画的UI不在当前屏幕时）消耗不必要的资源
    //duration 动画的时长，这里设置的 seconds: 2 为2秒，当然也可以设置毫秒 milliseconds：2000.
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        print("status is completed");
        //重置起点
        controller.reset();
        //开启
        controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法
        print("status is dismissed");
      } else if (status == AnimationStatus.forward) {
        print("status is forward");
        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态
        print("status is reverse");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.reverse();
    controller.dispose();
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
      controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: RotationTransition(
                        //设置动画的旋转中心
                        alignment: Alignment.center,
                        //动画控制器
                        turns: controller,
                        //将要执行动画的子view
                        child: Icon(Icons.autorenew)),
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
                      controller.forward();
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
                    errorListener: () {},
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
                      widget: BookDetailScreen(book: listBooks[index], type: 1),
                      type: 1));
            },
          ),
          Container(
            width: Screen.width - 165,
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
        SizedBox(height: 5),
        prefix1.Text(
          listBooks[index].name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        // prefix1.Text(listBooks[index].wordCount),
        prefix1.Text(
          listBooks[index].author,
          style: TextStyle(color: AppColor.grey),
        ),
        SizedBox(height: 5),
        prefix1.Text(
          "是否完结：" + listBooks[index].status,
          style: TextStyle(color: AppColor.grey),
        ),
        SizedBox(height: 5),
        prefix1.Text(
          "来源：" + listBooks[index].sourceType,
          style: TextStyle(color: AppColor.grey),
        ),
        SizedBox(height: 5),
        prefix1.Text(
          "介绍：" + listBooks[index].info.trim(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColor.grey),
        ),
        SizedBox(height: 5),

        // Row(
        //   children: <Widget>[
        //     RaisedButton(
        //       color: Colors.white,
        //       child: Text(
        //         '加入书桌',
        //       ),
        //       onPressed: () {
        //         print("加入书桌");
        //         addBookshelfApi(index);
        //       },
        //     ),
        //     Padding(
        //       padding: EdgeInsets.only(left: 5),
        //     ),
        //     RaisedButton(
        //       color: Colors.white,
        //       child: Text(
        //         '开始阅读',
        //       ),
        //       onPressed: () {
        //         goToRederScreen(index);
        //       },
        //     ),
        //   ],
        // ),

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
    ProgressDialog.showLoadingDialog(context, "解析目录中...");
    var book = this.listBooks[index];
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

    var path = await Config.getLocalFilePath(context);
    print("加入书桌的地址:${path + "/" + book.id.toString()}");
    Directory bfb = new Directory(path + "/" + book.id.toString());
    if (!bfb.existsSync()) {
      bfb.createSync(recursive: true);
    }
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
    Navigator.pop(context);
  }
}
