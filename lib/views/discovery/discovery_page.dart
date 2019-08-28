import 'package:flutter/material.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DiscoveryPageState();
  }
}

class DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('发现'),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
          child: Center(
              child: Icon(Icons.change_history,
                  size: 128.0, color: Colors.black12))),
    );
  }
}
