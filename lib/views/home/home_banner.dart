import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  @override
  State<HomeBanner> createState() => HomeBannerWidget();
}

class HomeBannerWidget extends State<HomeBanner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.fitHeight,
        image: NetworkImage("http://file.joucks.cn:3008/v2_pwtuzc.png"),
      ),
      foregroundDecoration: new BoxDecoration(
        border: new Border.all(
          color: Colors.grey[300],
          width: 0.0,
        ),
      ),
    );
  }
}
