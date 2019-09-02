import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/utility.dart';

import 'package:thief_book_flutter/models/article.dart';
import 'reader_overlayer.dart';
import 'reader_utils.dart';
import 'reader_config.dart';

class ReaderView extends StatelessWidget {
  final Article article;
  final int page;
  final double topSafeHeight;
  final double fontSize;

  ReaderView({this.article, this.page, this.topSafeHeight,this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Positioned(left: 0, top: 0, right: 0, bottom: 0, child: Image.asset('assets/images/read_bg.png', fit: BoxFit.cover)),
        ReaderOverlayer(
            article: article, page: page, topSafeHeight: topSafeHeight),
        buildContent(article, page),
      ],
    );
  }

  buildContent(Article article, int page){
    var content = article.stringAtPageIndex(page);
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
              style: TextStyle(fontSize: fixedFontSize(fontSize)))
        ]),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
