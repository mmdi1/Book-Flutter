import 'dart:async';
import 'package:flutter/material.dart';

import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/style/app_style.dart';
import 'package:thief_book_flutter/common/utils/navigator_utils.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/views/book/bookshelf_item_view.dart';
import 'package:thief_book_flutter/views/search/search_screen.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageWidgetState();
  }
}

class HomePageWidgetState extends State<HomePageWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String title = "当前1.70元/总共100.05元";
  var pageCount = 0;
  @override
  void initState() {
    print("+====初始Home_page");
    super.initState();
    fetchData();
  }

  List<Widget> bookItems = [];
  //初始数据
  Future<void> fetchData() async {
    var books = await BookApi.getBooks();
    bookItems = [];
    // bookItems.add(addItemView());
    books.forEach((book) {
      bookItems.add(BookshelfItemView(book));
    });
    print("书:${books.length},${bookItems.length / 9}");
    pageCount = (bookItems.length / 9).floor() + 1;
    print("-----------共多少页:$pageCount");
    setState(() {});
  }

  Widget _pageItemBuilder(BuildContext context, int index) {
    var starIndex = index * 9;
    var endIndex = starIndex + 9;
    var list = [];
    if (index == pageCount - 1) {
      list = bookItems.sublist(starIndex);
    } else {
      list = bookItems.sublist(starIndex, endIndex);
    }
    print("+==========$starIndex, $endIndex");
    return Wrap(
      spacing: 23,
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBarView(),
      body: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
          child: PageView.builder(
            itemCount: pageCount,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: _pageItemBuilder,
          )),
    );
  }

  Widget buildAppBarView() {
    return new AppBar(
      elevation: 1,
      leading: new IconButton(
        icon: new Container(
          padding: EdgeInsets.all(3.0),
          child: ClipOval(
            child: Image(
              height: 40,
              width: 40,
              image: NetworkImage(
                  "http://7xqekd.com1.z0.glb.clouddn.com/imgs/24910959%20%281%29.jpeg"),
            ),
          ),
          //    new CircleAvatar(
          //       radius: 30.0,
          //       backgroundImage:
          //           AssetImage("assets/images/avatar.png")),
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context, CustomRoute(widget: SearchSreenWidget(
              onSetState: () {
                fetchData();
              },
            )));
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            fetchData();
          },
        ),
      ],
      title: Center(
        child: new Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // flexibleSpace: Column(
      //   children: <Widget>[
      //     Padding(padding: new EdgeInsets.fromLTRB(0, 40, 0, 0)),
      //     Text(storew.state.progressData)
      //   ],
      // ),
    );
  }

  Widget pageItemView() {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5)),
        Wrap(
          spacing: 23,
          children: bookItems,
        ),
      ],
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
