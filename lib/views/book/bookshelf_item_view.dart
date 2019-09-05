import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thief_book_flutter/common/style/app_style.dart';
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
      //长按
      onLongPress: () {
        _openModalBottomSheet(context, book);
      },
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      fit: BoxFit.cover,
                      width: width,
                      height: width / 0.75,
                      image: CachedNetworkImageProvider(
                        book.imgUrl,
                        errorListener: () {
                          print("图片加载错误---${book.imgUrl}");
                        },
                      ),
                    ),
                  ],
                ),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
              ),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Color(0x22000000), blurRadius: 5)
              ]),
            ),
            SizedBox(height: 10),
            Text(" " + book.name,
                style: TextStyle(fontSize: 14, color: AppColor.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Future _openModalBottomSheet(BuildContext context, Book book) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('详情'),
                  onTap: () {
                    Navigator.pop(context, 'A');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('删除'),
                  onTap: () {
                    Navigator.pop(context, 'C');
                  },
                ),
              ],
            ),
          );
        });

    print(option);
  }
}
