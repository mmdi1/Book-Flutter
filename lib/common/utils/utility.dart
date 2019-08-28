
import 'package:flutter/widgets.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';

afterLayout(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
    callback();
  });
}

fixedFontSize(double fontSize) {
  return fontSize / Screen.textScaleFactor;
}
