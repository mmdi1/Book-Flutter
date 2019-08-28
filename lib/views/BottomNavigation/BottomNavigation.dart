import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/views/about/about_page.dart';
import 'package:thief_book_flutter/views/discovery/discovery_page.dart';
import 'package:thief_book_flutter/views/home/home_page.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BottomNavigationWidgetState();
  }
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  List<Widget> pages = new List();

  @override
//initState是初始化函数，在绘制底部导航控件的时候就把这3个页面添加到list里面用于下面跟随标签导航进行切换显示
  initState() {
    pages..add(HomePageWidget())..add(DiscoveryPage())..add(AboutPage());
  }

  @override
  Widget build(BuildContext context) {
    /*
    返回一个脚手架，里面包含两个属性，一个是底部导航栏，另一个就是主体内容
     */
    return new Scaffold(
      //主体显示的页面跟随当前导航标签的位标值在pages页面列表中选择。
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //底部导航栏的创建需要对应的功能标签作为子项，这里我就写了3个，每个子项包含一个图标和一个title。
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: new Text(
                '首页',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.reorder,
              ),
              title: new Text(
                '发现',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.mood,
              ),
              title: new Text(
                '关于',
              )),
        ],

        //这是底部导航栏自带的位标属性，表示底部导航栏当前处于哪个导航标签。给他一个初始值0，也就是默认第一个标签页面。
        currentIndex: _currentIndex,
        //这是点击属性，会执行带有一个int值的回调函数，这个int值是系统自动返回的你点击的那个标签的位标
        onTap: (int i) {
          //进行状态更新，将系统返回的你点击的标签位标赋予当前位标属性，告诉系统当前要显示的导航标签被用户改变了。
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}
