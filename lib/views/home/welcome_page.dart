import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/common/utils/db_utils.dart';
import 'package:thief_book_flutter/views/BottomNavigation/BottomNavigation.dart';
import 'package:thief_book_flutter/views/down/down_server.dart';
import 'package:redux/redux.dart';

class SplashScreen extends StatefulWidget {
  Store<ReduxState> store;
  SplashScreen(this.store);
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  List<Slide> slides = new List();
  @override
  void initState() {
    RegExp exp = new RegExp(r"第\W+.{1,10}章");
    var str = exp.stringMatch("全英文也完全第的微乎dfSD卡的说的说的是其微IE我去诶我章陈的看法技能等级");
    print("---------------$str");
    DownApi.requestPermission();
    super.initState();
    slides.add(
      new Slide(
        title: "C.TEAM 出品",
        description:
            "官网:https://c.team\n\nC.TEAM是创新团队\n\nC.TEAM旗下有很多爆款产品 \n并且C.TEAM产品是完全免费、开源",
        styleDescription: TextStyle(
            color: Colors.white, fontSize: 20.0, fontFamily: 'Raleway'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        colorBegin: Color(0xffFFDAB9),
        colorEnd: Color(0xff40E0D0),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
      ),
    );
    initApp();
    // slides.add(
    //   new Slide(
    //     title: "Wanandroid",
    //     description:
    //         "这是一款使用Flutter写的WanAndroid客户端应用，在Android和IOS都完美运行,可以用来入门Flutter，简单明了，适合初学者,项目完全开源，如果本项目确实能够帮助到你学习Flutter，谢谢start，有问题请提交Issues,我会及时回复。",
    //     styleDescription: TextStyle(
    //         color: Colors.white, fontSize: 20.0, fontFamily: 'Raleway'),
    //     marginDescription:
    //         EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
    //     colorBegin: Color(0xffFFFACD),
    //     colorEnd: Color(0xffFF6347),
    //     directionColorBegin: Alignment.topLeft,
    //     directionColorEnd: Alignment.bottomRight,
    //   ),
    // );
    // slides.add(
    //   new Slide(
    //     title: "Welcome",
    //     description: "赠人玫瑰，手有余香；\n分享技术，传递快乐。",
    //     styleDescription: TextStyle(
    //         color: Colors.white, fontSize: 20.0, fontFamily: 'Raleway'),
    //     marginDescription:
    //         EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
    //     colorBegin: Color(0xffFFA500),
    //     colorEnd: Color(0xff7FFFD4),
    //     directionColorBegin: Alignment.topLeft,
    //     directionColorEnd: Alignment.bottomRight,
    //   ),
    // );
  }

  void initApp() async {
    await DbUtils.initDbTabel();
    // await Request.get("");
  }

  void onDonePress() {
    // _setHasSkip();
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            // builder: (context) => ReadScreen(1)),
            builder: (context) => BottomNavigationWidget(this.widget.store)),
        (route) => route == null);
  }

  void _setHasSkip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasSkip", true);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      nameSkipBtn: "跳过",
      nameNextBtn: "下一页",
      nameDoneBtn: "进入",
    );
  }
}
