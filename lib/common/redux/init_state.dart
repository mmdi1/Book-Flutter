import 'package:flutter/material.dart';
import 'package:thief_book_flutter/common/redux/progress_redux.dart';
import 'package:thief_book_flutter/common/redux/theme_redux.dart';

class ReduxState {
  ///用户信息
  // User userInfo;

  ///主题数据
  ThemeData themeData;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;
  //后台进度
  String progressData;
  //title
  String title;

  ///构造方法
  ReduxState({this.themeData, this.progressData,this.title});
}

///创建 Reducer
///源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
///我们自定义了 appReducer 用于创建 store
ReduxState appReducer(ReduxState state, action) {
  print("appReducer=========${state.progressData}");
  return ReduxState(
    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),
    progressData: ProgressDataReducer(state.progressData, action),

    ///通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    // locale: LocaleReducer(state.locale, action),
  );
}
