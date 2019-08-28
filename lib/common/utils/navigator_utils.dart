import 'package:flutter/material.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/views/down/down_page.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';

class AppNavigator {
  static push(BuildContext context, Widget scene) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => scene,
      ),
    );
  }

  static pushNovelDetail(BuildContext context, Book book) {
    AppNavigator.push(context, ReaderScene(novelId: book.id));
  }

  static pushDownloadPage(BuildContext context) {
    AppNavigator.push(context, DownPageView());
  }

  // static pushLogin(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return LoginScene();
  //   }));
  // }

  // static pushWeb(BuildContext context, String url, String title) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return WebScene(url: url, title: title);
  //   }));
  // }

  // static pushReader(BuildContext context, int articleId) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return ReaderScene(articleId: articleId);
  //   }));
  // }
}
