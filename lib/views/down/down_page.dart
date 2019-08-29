import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/common/utils/io_utils.dart';
import 'package:thief_book_flutter/common/utils/navigator_utils.dart';
import 'package:thief_book_flutter/views/down/down_server.dart';

class DownPageView extends StatefulWidget {
  @override
  DownPageViewState createState() => DownPageViewState();
}

/// 下载页 */
class DownPageViewState extends State<DownPageView> {
  final TextEditingController urlController = new TextEditingController();
  var downUrl = "http://file.joucks.cn:3008/jianlai.txt";
  var bookName = "剑来";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
    return new StoreBuilder<ReduxState>(builder: (context, store) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text('下载页'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text("请输入txt下载地址"),
                new Padding(padding: new EdgeInsets.all(20.0)),
                bookNameTextView(),
                new Padding(padding: new EdgeInsets.all(20.0)),
                inputTextView(),
                new Padding(padding: new EdgeInsets.all(30.0)),
                downBtnView(context, store),
              ],
            ),
          ),
        ),
      );
    });
  }

  //url输入框
  Widget bookNameTextView() {
    return new TextField(
      onChanged: (String value) {
        bookName = value;
      },
      decoration: new InputDecoration(
        hintText: '给小说命个名吧',
      ),
    );
  }

  //url输入框
  Widget inputTextView() {
    return new TextField(
      onChanged: (String value) {
        downUrl = value;
      },
      decoration: new InputDecoration(
        hintText: 'http://baidupan.com/剑来.txt',
        suffixIcon: new IconButton(
          icon: new Icon(Icons.clear, color: Colors.black45),
          onPressed: () {
            urlController.clear();
          },
        ),
      ),
    );
  }

  //下载按钮
  Widget downBtnView(BuildContext context, store) {
    return new RaisedButton(
        padding: new EdgeInsets.only(
            left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
        textColor: Colors.white,
        color: Colors.blue,
        child: new Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: <Widget>[
            new Text("下载",
                style: new TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
          ],
        ),
        onPressed: () async {
          // 获取存储路径
          var path = await Config.getLocalFilePath(context);
          downUrl = "http://file.joucks.cn:3008/zui.txt";
          print("下载地址：$downUrl,下载到：$path");
          //"http://file.joucks.cn:3008/jianlai.txt"
          DownApi.downloadFile(bookName, downUrl, path);
          downFileCb(context, store);
        });
  }

  downFileCb(BuildContext cxt, store) async {
    ProgressDialog pr = new ProgressDialog(cxt, ProgressDialogType.Download);
    pr.setMessage('下载中…');
    // 设置下载回调
    FlutterDownloader.registerCallback((id, status, progress) {
      // 打印输出下载信息
      if (!pr.isShowing()) {
        pr.show();
      }
      if (status == DownloadTaskStatus.running) {
        pr.update(progress: progress.toDouble(), message: "下载中，请稍后…");
      }
      if (status == DownloadTaskStatus.failed) {
        // showToast("下载异常，请稍后重试");
        print("下载异常!!");
        if (pr.isShowing()) {
          pr.hide();
        }
      }
      if (status == DownloadTaskStatus.complete) {
        print(pr.isShowing());
        if (pr.isShowing()) {
          pr.hide();
        }

        showDialog(
            // 设置点击 dialog 外部不取消 dialog，默认能够取消
            barrierDismissible: false,
            context: cxt,
            builder: (context) => AlertDialog(
                  title: Text('提示'),
                  // 标题文字样式
                  content: Text('文件下载完成，是否后台解析章节？'),
                  // 内容文字样式
                  backgroundColor: CupertinoColors.white,
                  elevation: 8.0,
                  // 投影的阴影高度
                  semanticLabel: 'Label',
                  // 这个用于无障碍下弹出 dialog 的提示
                  shape: Border.all(),
                  // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
                  actions: <Widget>[
                    // 点击取消按钮
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('取消')),
                    // 点击打开按钮
                    FlatButton(
                        onPressed: () async {
                          // 获取存储路径
                          var path = await Config.getLocalFilePath(context);
                          // var txtName =
                          //     downUrl.substring(downUrl.lastIndexOf("/"));
                          // print("path:$path,txtName:$txtName");
                          IoUtils.splitTxtByStream(
                              bookName, path + "/" + bookName + ".txt", store);
                          // Navigator.pop(context);
                          AppNavigator.pushHome(context, store);
                          // 打开文件
                        },
                        child: Text('确认')),
                  ],
                ));
      }
    });
  }
}
