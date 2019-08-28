import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/utility.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/views/read/reader_config.dart';
import 'package:thief_book_flutter/views/read/reader_utils.dart';
import 'package:thief_book_flutter/views/reader/reader_overlayer.dart';

class ReadView extends StatelessWidget {
  final Article article;
  final int page;
  final double topSafeHeight;
  ReadView({this.article, this.page, this.topSafeHeight});
  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return Stack(children: <Widget>[
        Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/read_bg.png', fit: BoxFit.cover)),
      ]);
    }
    return Stack(
      children: <Widget>[
        Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/read_bg.png', fit: BoxFit.cover)),
        ReaderOverlayer(
            article: article, page: page, topSafeHeight: topSafeHeight),
        buildContent(article, page),
      ],
    );
  }

  buildContent(Article article, int page) {
    if (article == null) {
      return Container();
    }
    var content = article.stringAtPageIndex(page);
    print("页数:$page,内容:$content");
    if (content.startsWith('\n')) {
      content = content.substring(1);
    }
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(15, topSafeHeight + ReaderUtils.topOffset, 10,
          Screen.bottomSafeHeight + ReaderUtils.bottomOffset),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
              text: content,
              style: TextStyle(
                  fontSize: fixedFontSize(ReaderConfig.instance.fontSize)))
        ]),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
