import 'dart:async';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/server/books_curd.dart';
import 'package:thief_book_flutter/common/style/app_style.dart';
import 'package:thief_book_flutter/common/utils/navigator_utils.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/views/book/bookshelf_item_view.dart';
import 'package:thief_book_flutter/views/search/search_screen.dart';
import 'package:thief_book_flutter/views/user/my_setting.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageWidgetState();
  }
}

class HomePageWidgetState extends State<HomePageWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  var pageCount = 0;
  var isBuildMenu = false;
  @override
  void initState() {
    print("+====初始Home_page");
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> bookItems = [];
  //初始数据
  Future<void> fetchData() async {
    var books = await BookApi.getBooks();
    bookItems = [];
    // bookItems.add(addItemView());
    books.forEach((book) {
      print("forEach------book:${book.toJson()}");
      bookItems.add(BookshelfItemView(book));
    });
    print("书:${books.length},${bookItems.length / 9}");
    pageCount = (bookItems.length / 9).floor() + 1;
    print("主页加载书:${books.length},分页:${bookItems.length / 9},共多少页:$pageCount");
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
    return Wrap(
      spacing: 23,
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: MySetting(),
        appBar: buildAppBarView(),
        body: Container(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: PageView.builder(
              itemCount: pageCount,
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: _pageItemBuilder,
            )));
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
          icon: Icon(Icons.more_vert),
          onPressed: () {
            showDialogWithOffset(handle: fromRight);
          },
        )
      ],
      title: Center(
        child: new Text(
          "当前1.8元/总共10.05元",
          // MoreLocalization.of(context).,
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

  Offset fromLeft(Animation animation) {
    return Offset(animation.value - 1, 0);
  }

  Offset fromRight(Animation animation) {
    return Offset(1 - animation.value, 0);
  }

  Offset fromTop(Animation animation) {
    return Offset(0, animation.value - 1);
  }

  Offset fromBottom(Animation animation) {
    return Offset(0, 1 - animation.value);
  }

  Offset fromTopLeft(Animation anim) {
    return fromLeft(anim) + fromTop(anim);
  }

  Widget buildButton(
    String text,
    Function onPressed, {
    Color color = Colors.white,
  }) {
    return FlatButton(
      color: color,
      child: Text(text),
      onPressed: onPressed,
    );
  }

  var value;
  //遮罩并显示菜单
  showDialogWithOffset({handle}) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: "",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        BuildContext context,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(top: 100, right: 0),
          child: Column(
            children: <Widget>[
              buildMenuRadius(
                  new BorderRadius.only(topLeft: new Radius.circular(5.0))),
              buildMenu(),
              buildMenu(),
              buildMenuRadius(
                  new BorderRadius.only(bottomLeft: new Radius.circular(5.0))),
            ],
          ),
        );
      },
      transitionBuilder: (ctx, animation, _, child) {
        return FractionalTranslation(
          translation: handle(animation),
          child: child,
        );
      },
    );
  }

  Widget buildMenu() {
    return Container(
      width: 60,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(
            color: Colors.white,
            width: 1,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.settings),
          Text("设置",
              style: TextStyle(
                fontSize: 12,
              ))
        ],
      ),
    );
  }

  Widget buildMenuRadius(BorderRadiusGeometry borderRadius) {
    return Container(
      width: 60,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(
            color: Colors.white10,
            width: 1,
          ),
          borderRadius: borderRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.settings),
          Text("设置",
              style: TextStyle(
                fontSize: 12,
              ))
        ],
      ),
    );
  }
}
