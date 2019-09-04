import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/utils/sp_uitls.dart';

class ReaderConfig {
  static ReaderConfig _instance;
  static ReaderConfig get instance {
    if (_instance == null) {
      _instance = ReaderConfig();
    }
    return _instance;
  }

  double fontSize = 20.0;
  bool _isVertical = false;
  Future<double> getFontSize() async {
    var cacheFontSize = await SpUtils.getInt(Config.spCacheFontSize);
    if (cacheFontSize == null) {
      return fontSize;
    }
    return cacheFontSize.toDouble();
  }

  //横屏竖屏切换
  Future<bool> isVertical() async {
    var cacheData = await SpUtils.getBool(Config.spCacheVertical);
    if (cacheData == null) {
      return cacheData;
    }
    return _isVertical;
  }
}
