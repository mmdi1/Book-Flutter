import 'package:flutter/material.dart';
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
  int initFontSize = ReaderConfig.instance.fontSize.toInt();
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
    print("initFontSize========$initFontSize,$spFontSize");
    if (spFontSize != null) {
      initFontSize = spFontSize;
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
    if (isEditSetting) {
      this.widget.onEditSetting();
    }
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
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
                },
                child: Image.asset('assets/images/pub_back_gray.png'),
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  Toast.show("功能暂未开放~");
                },
                child: Image.asset('assets/images/read_icon_voice.png'),
              ),
            ),
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  print("--------");
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
              padding: EdgeInsets.all(20),
              child:
                  Image.asset('assets/images/read_icon_chapter_previous.png'),
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
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/images/read_icon_chapter_next.png'),
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

  //设置字体大小
  settingFontSizeFunc(size) {
    SpUtils.setInt(Config.spCacheFontSize, size);
    isEditSetting = true;
    setState(() {});
  }

  //字体设置
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
                      buidIconBtnWdget(Icons.font_download, () {
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
                      buidIconBtnWdget(Icons.font_download, () {
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
                  buildTitleWdget("段落"),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      buidIconBtnWdget(Icons.format_align_center, () {}),
                      buidIconBtnWdget(Icons.format_align_center, () {}),
                      buidIconBtnWdget(Icons.format_align_center, () {}),
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
                  buildTitleWdget("行间距"),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      buidIconBtnWdget(Icons.format_align_left, () {}),
                      buidIconBtnWdget(Icons.format_align_justify, () {}),
                      buidIconBtnWdget(Icons.format_align_right, () {}),
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

  Widget buidIconBtnWdget(IconData icon, Function _onPressed) {
    var widthNum = (Screen.width - 11) / 3;
    var iconWidthNum = widthNum / 3;
    return Container(
      width: iconWidthNum,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon),
        onPressed: _onPressed,
      ),
    );
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

  //底部按钮
  buildBottomMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildBottomItem(
            'list', 'assets/images/read_icon_catalog.png', Icons.list),
        // buildBottomItem('亮度', 'assets/images/read_icon_brightness.png'),
        buildBottomItem('progress', 'assets/images/read_icon_setting.png',
            Icons.all_inclusive),
        buildBottomItem(
            'font', 'assets/images/read_icon_font.png', Icons.format_size),
      ],
    );
  }

  //底部按钮单个
  buildBottomItem(String title, String iconImg, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: GestureDetector(
        onTap: () {
          Toast.show("功能暂未开放");
        },
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(icon),
              onPressed: () {
                _onPressedMenu(title);
              },
            ),

            SizedBox(height: 5),
            // Text(title,
            //     style: TextStyle(
            //         fontSize: fixedFontSize(12), color: SQColor.darkGray)),
          ],
        ),
      ),
    );
  }

  //点击底部菜单按钮
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
