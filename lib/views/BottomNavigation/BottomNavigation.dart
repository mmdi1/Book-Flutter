import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/views/about/about_page.dart';
import 'package:thief_book_flutter/views/discovery/discovery_page.dart';
import 'package:thief_book_flutter/views/home/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:thief_book_flutter/views/search/search_screen.dart';
import 'package:thief_book_flutter/views/user/my_setting.dart';
import 'package:thief_book_flutter/widgets/custome_router.dart';

class BottomNavigationWidget extends StatefulWidget {
  var store;
  BottomNavigationWidget(this.store);
  @override
  State<StatefulWidget> createState() {
    return new BottomNavigationWidgetState();
  }
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String title = "书架";
  List<Widget> pages = new List();
  //Tab页的控制器，可以用来定义Tab标签和内容页的坐标
  TabController tabcontroller;
//initState是初始化函数，在绘制底部导航控件的时候就把这3个页面添加到list里面用于下面跟随标签导航进行切换显示
  @override
  initState() {
    tabcontroller = new TabController(
      length: 1, vsync: this, //Tab页的个数
      //动画效果的异步处理，默认格式
    );
    super.initState();
    pages..add(HomePageWidget());//..add(DiscoveryPage())..add(AboutPage());
  }

  @override
  void dispose() {
    if (tabcontroller != null) {
      tabcontroller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: this.widget.store,
        child: new StoreBuilder<ReduxState>(builder: (context, storew) {
          return DefaultTabController(
            child: new Scaffold(
              key: _scaffoldKey,
              drawer: MySetting(),
              appBar: new AppBar(
                leading: new IconButton(
                  icon: new Container(
                    padding: EdgeInsets.all(3.0),
                    child: ClipOval(
                      child: Image(
                        height: 40,
                        width: 40,
                        image: NetworkImage(
                            "https://avatars0.githubusercontent.com/u/24910959?s=460&v=4"),
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
                      Navigator.push(
                          context, CustomRoute(widget: SearchSreenWidget()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      print("刷新操作");
                    },
                  ),
                ],
                title: new Text(title),
                // flexibleSpace: Column(
                //   children: <Widget>[
                //     Padding(padding: new EdgeInsets.fromLTRB(0, 40, 0, 0)),
                //     Text(storew.state.progressData)
                //   ],
                // ),
              ),
              //主体显示的页面跟随当前导航标签的位标值在pages页面列表中选择。
              body: TabBarView(
                controller: tabcontroller,
                children: pages,
              ),
              // bottomNavigationBar: new Material(
              //   child: TabBar(
              //     onTap: (index) {
              //       tabcontroller.animateTo(index);
              //     },
              //     //tab被选中时的颜色，设置之后选中的时候，icon和text都会变色
              //     labelColor: Colors.amber,
              //     //tab未被选中时的颜色，设置之后选中的时候，icon和text都会变色
              //     unselectedLabelColor: Colors.black,
              //     tabs: <Widget>[
              //       Tab(icon: Icon(Icons.home)),
              //       Tab(icon: Icon(Icons.change_history)),
              //       Tab(icon: Icon(Icons.mood)),
              //     ],
              //   ),
              // ),
            ),
            length: 3,
          );
        }));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return new StoreProvider(
  //       store: this.widget.store,
  //       child: new StoreBuilder<ReduxState>(builder: (context, storew) {
  //         return new Scaffold(
  //           appBar: new AppBar(

  //             actions: <Widget>[
  //               IconButton(
  //                 icon: Icon(Icons.search),
  //                 onPressed: (){
  //                   print("search");
  //                 },
  //               ),
  //             ],
  //             title: new Text(title),
  //             flexibleSpace: Column(
  //               children: <Widget>[
  //                 Padding(padding: new EdgeInsets.fromLTRB(0, 40, 0, 0)),
  //                 Text(storew.state.progressData)
  //               ],
  //             ),
  //           ),
  //           //主体显示的页面跟随当前导航标签的位标值在pages页面列表中选择。
  //           body: pages[_currentIndex],
  //           bottomNavigationBar: BottomNavigationBar(
  //             //底部导航栏的创建需要对应的功能标签作为子项，这里我就写了3个，每个子项包含一个图标和一个title。
  //             items: [
  //               BottomNavigationBarItem(
  //                   icon: Icon(
  //                     Icons.home,
  //                   ),
  //                   title: new Text(
  //                     '书架',
  //                   )),
  //               BottomNavigationBarItem(
  //                   icon: Icon(
  //                     Icons.change_history,
  //                   ),
  //                   title: new Text(
  //                     '发现',
  //                   )),
  //               BottomNavigationBarItem(
  //                   icon: Icon(
  //                     Icons.mood,
  //                   ),
  //                   title: new Text(
  //                     '关于',
  //                   )),
  //             ],

  //             //这是底部导航栏自带的位标属性，表示底部导航栏当前处于哪个导航标签。给他一个初始值0，也就是默认第一个标签页面。
  //             currentIndex: _currentIndex,
  //             //这是点击属性，会执行带有一个int值的回调函数，这个int值是系统自动返回的你点击的那个标签的位标
  //             onTap: (int i) {
  //               if (i == 0) {
  //                 title = "书架";
  //               } else if (i == 1) {
  //                 title = "发现";
  //               } else if (i == 2) {
  //                 title = "关于";
  //               }
  //               //进行状态更新，将系统返回的你点击的标签位标赋予当前位标属性，告诉系统当前要显示的导航标签被用户改变了。
  //               setState(() {
  //                 _currentIndex = i;
  //               });
  //             },
  //           ),
  //         );
  //       }));
  // }
}
