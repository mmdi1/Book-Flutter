import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';

import 'package:thief_book_flutter/models/chapter.dart';

class ReaderCatalog extends StatefulWidget {
  final List<Chapter> chapters;
  final int articleIndex;
  final void Function(Chapter chapter) onToggleCatalog;

  ReaderCatalog({this.chapters, this.articleIndex, this.onToggleCatalog});

  @override
  _ReaderCatalogState createState() => _ReaderCatalogState();
}

class _ReaderCatalogState extends State<ReaderCatalog> {
  var _scrollController = new ScrollController();
  var _ITEM_HEIGHT = 45;
  // AnimationController animationController;
  // Animation<double> animation;
  // double progressValue;

  @override
  initState() {
    super.initState();
    goToCurrentIndex();
    // progressValue =
    //     this.widget.articleIndex / (this.widget.chapters.length - 1);
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 200), vsync: this);
    // animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    // animation.addListener(() {
    //   setState(() {});
    // });
    // animationController.forward();
  }

  // @override
  // void didUpdateWidget(ReaderCatalog oldWidget) {
  // super.didUpdateWidget(oldWidget);
  // progressValue =
  //     this.widget.articleIndex / (this.widget.chapters.length - 1);
  // }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  goToCurrentIndex() {
    print("==========${this.widget.articleIndex}");
    Timer(
        Duration(milliseconds: 500),
        () => {
              _scrollController.animateTo(
                  this.widget.articleIndex == null
                      ? 0
                      : this.widget.articleIndex.toDouble() * _ITEM_HEIGHT,
                  duration: new Duration(seconds: 1),
                  curve: Curves.ease)
            });
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    var color = Colors.white;
    if (index == this.widget.articleIndex) {
      color = Colors.blue[100];
    }
    return FlatButton(
      color: color,
      splashColor: Colors.white,
      child: Text(this.widget.chapters[index].title),
      onPressed: () {
        this.widget.onToggleCatalog(this.widget.chapters[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Screen.navigationBarHeight,
          bottom: Screen.bottomSafeHeight,
          left: 30,
          right: 30),
      color: Colors.white,
      height: Screen.height - 350,
      padding: EdgeInsets.all(3.0),
      child: new Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "目录",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        new Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: this.widget.chapters.length,
            itemBuilder: _listItemBuilder,
          ),
        )
      ]),
    );
  }
}
