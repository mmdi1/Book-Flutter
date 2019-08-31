import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as prefix0;
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/utils/http.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:thief_book_flutter/models/book.dart';
import 'package:thief_book_flutter/views/search/search_appbar.dart';

class SearchSreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchSreenWidgetState();
  }
}

class SearchSreenWidgetState extends State<SearchSreenWidget> {
  String searchStr = "";
  var isflag = true;
  @override
  void initState() {
    txtController.addListener((){
      print("ccccccc");
    });
    focusNodeController.addListener((){
      print("aaaaaa");
    });
    super.initState();
  }
  TextEditingController txtController;
  FocusNode focusNodeController;
  List<Widget> bookItems = [];
  List<Book> listBooks = new List<Book>(); //列表要展示的数据
  //https://www.aixdzs.com/爱下电子书
  //初始数据
  Future<void> fetchData() async {
    var baseUrl = "https://www.aixdzs.com";
    // var path = await Config.getLocalFilePath(context);
    final res = await Http.get(
        baseUrl + "/bsearch?q=%E6%9C%80%E5%BC%BA%E5%BC%83%E5%B0%91");
    // File cf = new File(path + "/res.txt");
    // // cf.writeAsStringSync(json.encode(out));

    var str = utf8.decode(res);
    var html = parse(str);
    var content = html.querySelector(".box_k");
    List<prefix0.Element> list = content.querySelectorAll("li");
    list.forEach((e) {
      var listImg = e.querySelector(".list_img");
      var img = listImg.querySelector("img");
      var imgUrl = img.attributes["src"];
      var bookName = e.querySelector(".b_name").children[0].text;
      var info = e.querySelector(".b_intro").text;
      var author = e.querySelector(".l1").text;
      var count = e.querySelector(".l2").text; //字数
      var status = e.querySelector(".cp").text; //完结 连载
      var hrefStr = e.querySelector(".b_name").children[0].attributes["href"];
      var s = hrefStr.substring(0, hrefStr.length - 2);
      var id = s.substring(s.lastIndexOf("/") + 1);
      var downTxt = baseUrl + "/down?id=" + id + "&p=1";
      // https: //www.aixdzs.com/down?id=58741&p=1
      var book = new Book(
          importUrl: downTxt,
          name: bookName,
          author: author,
          info: info,
          wordCount: count,
          imgUrl: imgUrl,
          status: status);
      listBooks.add(book);
      print(
          "id:$id,书名:$bookName,作者:$author,字数:$count,状态:$status,封面:$imgUrl,txt下载地址:$downTxt");
      setState(() {});
    });
  }

  /*
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    if (isflag) {
      fetchData();
      isflag = false;
    }
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new SearchAppBarWidget(
        focusNode: focusNodeController,
        controller: txtController,
        elevation: 2.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              print("xxxxxxxxx");
              // Navigator.pop(context);
            }),
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
        ],
        onEditingComplete: () => print("222"),
      ),
      body: buildListView(),

      //  Container(
      //     padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      //     child: Column(
      //       children: <Widget>[
      //         Padding(padding: EdgeInsets.all(20)),
      //         titleTextView(),
      //         infoTextView(),
      //         buildEmailTextField(),
      //         buildListView(),
      //       ],
      //     )),
    );
  }

  Widget titleTextView() {
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 20)),
        prefix1.Text(
          "Search",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 34,
          ),
        ),
      ],
    );
  }

  Widget infoTextView() {
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 20)),
        prefix1.Text(
          "book name!",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget buildEmailTextField() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: TextFormField(
          scrollPadding: EdgeInsets.all(2),
          autofocus: true,
          onFieldSubmitted: (v) => print(v),
          onSaved: (String value) => searchStr = value,
        ));
  }

  ScrollController _scrollController = ScrollController(); //listview的控制器
  Widget buildListView() {
    print("111111111111");
    return Container(
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: _renderRow,
        itemCount: listBooks.length + 1,
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < listBooks.length) {
      return Container(
        child: Wrap(
          children: <Widget>[
            prefix1.Text(listBooks[index].name),
            prefix1.Text(listBooks[index].author),
            prefix1.Text("介绍:" + listBooks[index].info.trim()),
            prefix1.Text(listBooks[index].status),
            prefix1.Text(listBooks[index].wordCount),
          ],
        ),
      );
    }
  }
}
