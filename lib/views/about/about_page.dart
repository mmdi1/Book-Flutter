import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('关于'),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
          child: Center(
              child: Icon(Icons.mood, size: 128.0, color: Colors.black12))),
    );
  }
}
