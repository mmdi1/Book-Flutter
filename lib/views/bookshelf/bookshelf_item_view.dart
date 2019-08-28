import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thief_book_flutter/common/utils/navigator_utils.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/models/book.dart';

/// 首页小说 */
class BookshelfItemView extends StatelessWidget {
  final Book book;
  BookshelfItemView(this.book);
  @override
  Widget build(BuildContext context) {
    var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
    return GestureDetector(
      onTap: () {
        AppNavigator.pushNovelDetail(context, book);
      },
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              child: Container(
                child: Image(
                  image: CachedNetworkImageProvider(
                      "http://img-tailor.11222.cn/bcv/big/201901031812421599.jpg"),
                  fit: BoxFit.cover,
                  width: width,
                  height: width / 0.75,
                ),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
              ),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Color(0x22000000), blurRadius: 5)
              ]),
            ),
            SizedBox(height: 10),
            Text(book.name,
                style: TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
