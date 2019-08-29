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
        body: Column(
      children: <Widget>[
        Container(
            child: Center(
                child: Icon(Icons.mood, size: 128.0, color: Colors.black12))),
      ],
    ));
  }
}
