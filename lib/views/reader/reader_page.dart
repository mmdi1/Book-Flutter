import 'package:flutter/material.dart';
import 'package:thief_book_flutter/views/reader/reader_overlayer.dart';

class ReaderPageWidget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return new ReaderPageWidgetState();
  }
}

class ReaderPageWidgetState extends State<ReaderPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/read_bg.png', fit: BoxFit.cover)),
        ReaderOverlayer(),
        buildContent(),
      ],
    );
  }

  buildContent() {
    // var content = article.stringAtPageIndex(page);

    // if (content.startsWith('\n')) {
    //   content = content.substring(1);
    // }
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(15, 55, 10, 0),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: "123123", style: TextStyle(fontSize: 14))
        ]),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
