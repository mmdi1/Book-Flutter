import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/utils/SQColor.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/sp_uitls.dart';
import 'package:thief_book_flutter/common/utils/toast.dart';
import 'package:thief_book_flutter/common/utils/utility.dart';
import 'dart:async';

import 'package:thief_book_flutter/models/chapter.dart';
import 'package:thief_book_flutter/views/reader/reader_catalog.dart';
import 'package:thief_book_flutter/views/reader/reader_config.dart';

class ReaderMenu extends StatefulWidget {
  final List<Chapter> chapters;
  final int articleIndex;

  final VoidCallback onTap;
  final VoidCallback onPreviousArticle;
  final VoidCallback onNextArticle;
  final VoidCallback onEditSetting;
  final void Function(Chapter chapter) onToggleChapter;

  ReaderMenu(
      {this.chapters,
      this.articleIndex,
      this.onTap,
      this.onPreviousArticle,
      this.onNextArticle,
      this.onToggleChapter,
      this.onEditSetting});

  @override
  _ReaderMenuState createState() => _ReaderMenuState();
}

class _ReaderMenuState extends State<ReaderMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  double progressValue;
  bool isTipVisible = false;
  Color themColor = Colors.white;
  bool isShow = false;
  String isShowType = "";
  bool isEditSetting = false;
  bool isVertical = true;
  int initFontSize = ReaderConfig.instance.fontSize.toInt();
  Widget zj_svg =
      new SvgPicture.asset('assets/icons/zj.svg', width: 26, height: 26);
  Widget ml_svg =
      new SvgPicture.asset('assets/icons/ml.svg', width: 15, height: 15);
  Widget zhjc_svg =
      new SvgPicture.asset('assets/icons/zh_jc.svg', width: 30, height: 30);
  Widget zh1_svg =
      new SvgPicture.asset('assets/icons/zh_1.svg', width: 15, height: 15);
  Widget zh2_svg =
      new SvgPicture.asset('assets/icons/zh_2.svg', width: 14, height: 14);

  @override
  initState() {
    super.initState();
    initAsyncData();
    progressValue =
        this.widget.articleIndex / (this.widget.chapters.length - 1);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  //初始化异步参数
  initAsyncData() async {
    var spFontSize = await SpUtils.getInt(Config.spCacheFontSize);
    if (spFontSize != null) {
      initFontSize = spFontSize;
    }
    var spCacheVertical = await SpUtils.getBool(Config.spCacheVertical);
    if (spCacheVertical != null) {
      isVertical = spCacheVertical;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(ReaderMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    progressValue =
        this.widget.articleIndex / (this.widget.chapters.length - 1);
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
      if (isEditSetting) {
        this.widget.onEditSetting();
      }
    });
    setState(() {
      isTipVisible = false;
    });
  }

  buildTopView(BuildContext context) {
    return Positioned(
      top: -Screen.navigationBarHeight * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 8)]),
        height: Screen.navigationBarHeight,
        padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 5, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, "/home", (router) => router == null);
                },
                child: Image.asset('assets/images/pub_back_gray.png'),
              ),
            ),
            Expanded(
                child: Text(
                    this.widget.chapters[this.widget.articleIndex].title,
                    textAlign: TextAlign.center)),
            // Container(
            //   width: 44,
            //   child: GestureDetector(
            //     onTap: () {
            //       Toast.show("功能暂未开放~");
            //     },
            //     child: Image.asset('assets/images/read_icon_voice.png'),
            //   ),
            // ),
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  Toast.show("功能暂未开放~");
                },
                child: Image.asset('assets/images/read_icon_more.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int currentArticleIndex() {
    return ((this.widget.chapters.length - 1) * progressValue).toInt();
  }

  buildProgressTipView() {
    if (!isTipVisible) {
      return Container();
    }
    Chapter chapter = this.widget.chapters[currentArticleIndex()];
    double percentage =
        (chapter.index) / (this.widget.chapters.length - 1) * 100;
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff00C88D), borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              chapter.title.length > 15
                  ? chapter.title.substring(0, 15) + ".."
                  : chapter.title,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('${percentage.toStringAsFixed(1)}%',
              style: TextStyle(color: Colors.black, fontSize: 12)),
        ],
      ),
    );
  }

  previousArticle() {
    if (this.widget.articleIndex == 0) {
      // Toast.show('已经是第一章了');
      print("第一张了！！");
      return;
    }
    this.widget.onPreviousArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  nextArticle() {
    if (this.widget.articleIndex == this.widget.chapters.length - 1) {
      // Toast.show('已经是最后一章了');
      print("已经是最后一章了");
      return;
    }
    this.widget.onNextArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  //进度视图
  buildProgressView() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: previousArticle,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, style: BorderStyle.solid, color: Colors.black)),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(2),
              child: Text("上一章",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              // Image.asset('assets/images/read_icon_chapter_previous.png'),
            ),
          ),
          Expanded(
            child: Slider(
              value: progressValue,
              onChanged: (double value) {
                setState(() {
                  isTipVisible = true;
                  progressValue = value;
                });
              },
              onChangeEnd: (double value) {
                Chapter chapter = this.widget.chapters[currentArticleIndex()];
                this.widget.onToggleChapter(chapter);
              },
              activeColor: SQColor.primary,
              inactiveColor: SQColor.gray,
            ),
          ),
          GestureDetector(
            onTap: nextArticle,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, style: BorderStyle.solid, color: Colors.black)),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(2),
              child: Text("下一章",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              // Image.asset('assets/images/read_icon_chapter_next.png'),
            ),
          )
        ],
      ),
    );
  }

  //间隔线、
  buildRowLineWg() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: new Border.all(
          color: Colors.black,
          width: 0.2,
        ),
      ),
    );
  }

  //设置��体大小
  settingFontSizeFunc(size) {
    SpUtils.setInt(Config.spCacheFontSize, size);
    isEditSetting = true;
    setState(() {});
  }

  //二级菜单字体设置
  buildFontSettingView() {
    var widthNum = (Screen.width - 1) / 3;
    var iconWidthNum = widthNum / 3;
    return Container(
        color: Colors.grey[200],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: widthNum,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 8),
                  buildTitleWdget("字号"),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      buidIconBtnWdget(zh1_svg, () {
                        if (initFontSize == 12) {
                          Toast.show("已经是最小字号了");
                          return;
                        }
                        initFontSize--;
                        settingFontSizeFunc(initFontSize);
                      }),
                      Container(
                        width: iconWidthNum,
                        child: Text(
                          initFontSize.toString().substring(0, 2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      buidIconBtnWdget(zh2_svg, () {
                        if (initFontSize == 24) {
                          Toast.show("已经是最大字号了");
                          return;
                        }
                        initFontSize++;
                        settingFontSizeFunc(initFontSize);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            buildRowLineWg(),
            Container(
              width: widthNum,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 8),
                  buildTitleWdget("翻页方向"),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      buildAnimatedIcon(
                          Icons.swap_horizontal_circle, Icons.swap_horiz, true),
                      Container(
                        width: iconWidthNum,
                        child: Text(
                          " ",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      buildAnimatedIcon(
                          Icons.swap_vert, Icons.swap_vertical_circle, false),
                    ],
                  ),
                ],
              ),
            ),
            buildRowLineWg(),
            Container(
              width: widthNum,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 8),
                  buildTitleWdget("背景"),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      buidIconBtnWdget(Icon(Icons.format_align_left), () {
                        switchReaderBgFunc('assets/images/home_bg2.jpeg');
                      }),
                      buidIconBtnWdget(Icon(Icons.format_align_justify), () {
                        switchReaderBgFunc('assets/images/read_bg.jpeg');
                      }),
                      buidIconBtnWdget(Icon(Icons.format_align_right), () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildTitleWdget(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: fixedFontSize(14),
            fontWeight: FontWeight.w500,
            color: SQColor.darkGray));
  }

  Widget buidIconBtnWdget(Widget icon, Function _onPressed) {
    var widthNum = (Screen.width - 11) / 3;
    var iconWidthNum = widthNum / 3;
    return Container(
      width: iconWidthNum,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: icon,
        onPressed: _onPressed,
      ),
    );
  }

  //切换背景
  switchReaderBgFunc(String bgPath) {
    print("切换背景为:$bgPath");
    Config.readerBgImg = bgPath;
    SpUtils.setValue(Config.readerCackeKey, bgPath);
  }

  //二级菜单横竖平设置
  buildAnimatedIcon(IconData icon1, IconData icon2, bool left) {
    var widthNum = (Screen.width - 11) / 3;
    var iconWidthNum = widthNum / 3;
    return Container(
      width: iconWidthNum,
      child: GestureDetector(
        onTap: left ? settingLeftToRightFunc : settingTopToBottomFunc,
        child: Center(
          child: AnimatedCrossFade(
            firstChild: Container(
                child: Icon(icon1, size: 24), padding: EdgeInsets.all(11)),
            secondChild: Container(
                child: Icon(icon2, size: 24), padding: EdgeInsets.all(11)),
            //用于控制显示哪个widget
            crossFadeState: isVertical
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }

  //设置为左右翻页
  settingLeftToRightFunc() {
    isVertical = true;
    SpUtils.setBool(Config.spCacheVertical, true);
    isEditSetting = true;
    setState(() {});
  }

  //设置为上下翻页
  settingTopToBottomFunc() {
    isVertical = false;
    SpUtils.setBool(Config.spCacheVertical, false);
    isEditSetting = true;
    setState(() {});
  }

  //底部
  buildBottomView() {
    return Positioned(
      bottom: -(Screen.bottomSafeHeight + 110) * (1 - animation.value),
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          buildProgressTipView(),
          buildAnimatedSettingMenu(),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
            child: Column(
              children: <Widget>[
                buildBottomMenus(),
              ],
            ),
          )
        ],
      ),
    );
  }

  //二级菜单切换
  buildAnimatedSettingMenu() {
    Widget secondChild;
    if (isShowType == "font") {
      secondChild = buildFontSettingView();
    } else if (isShowType == "progress") {
      secondChild = buildProgressView();
    } else if (isShowType == "list") {
      secondChild = ReaderCatalog(
        chapters: this.widget.chapters,
        articleIndex: this.widget.articleIndex,
        onToggleCatalog: (Chapter chapter) {
          print("回调章节:${chapter.index},${chapter.title}");
          hide();
          this.widget.onToggleChapter(chapter);
        },
      );
    } else {
      secondChild = Container();
    }
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
          isShow ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: secondChild,
      secondChild: Container(),
    );
  }

  //一级菜单底部按钮
  buildBottomMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildBottomItem('list', 'assets/images/read_icon_catalog.png', ml_svg),
        // buildBottomItem('亮度', 'assets/images/read_icon_brightness.png'),
        buildBottomItem('progress', 'assets/icons/zj.svg', zj_svg),
        buildBottomItem('font', 'assets/images/read_icon_font.png', zhjc_svg),
      ],
    );
  }

  //底部按钮单个
  buildBottomItem(String title, String iconImg, Widget icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          Toast.show("功能暂未开放");
        },
        child: Column(
          children: <Widget>[
            IconButton(
              icon: icon,
              onPressed: () {
                _onPressedMenu(title);
              },
            ),

            // SizedBox(height: 5),
            // Text(title,
            //     style: TextStyle(
            //         fontSize: fixedFontSize(12), color: SQColor.darkGray)),
          ],
        ),
      ),
    );
  }

  //点击底���菜单按钮
  _onPressedMenu(String title) {
    if (title == isShowType) {
      isShow = !isShow;
    } else {
      isShow = true;
    }
    isShowType = title;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide();
            },
            child: Container(color: Colors.transparent),
          ),
          buildTopView(context),
          buildBottomView(),
        ],
      ),
    );
  }
}
