import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thief_book_flutter/views/home/home_banner.dart';

class SearchSreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchSreenWidgetState();
  }
}

class SearchSreenWidgetState extends State<SearchSreenWidget> {
  String searchStr = "";

  @override
  void initState() {
    super.initState();
  }

  List<Widget> bookItems = [];
  //初始数据
  Future<void> fetchData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
          child: Column(
            children: <Widget>[HomeBanner(),
            buildEmailTextField()],
          )),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      // autofocus: true,
      onFieldSubmitted: (v) => print(v),
      decoration: InputDecoration(
        labelText: '请输入您的邮箱地址',
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的邮箱地址';
        }
      },
      onSaved: (String value) => searchStr = value,
    );
  }
}
