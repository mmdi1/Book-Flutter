import 'package:redux/redux.dart';

///通过 flutter_redux 的 combineReducers，实现 Reducer 方法
final TitleDataReducer = combineReducers<String>([
  ///将 Action 、处理 Action 的方法、State 绑定
  TypedReducer<String, RefreshTitleDataAction>(_refresh),
]);
///定义处理 Action 行为的方法，返回新的 State
String _refresh(String title, action) {
  title = action.progressNum;
  return title;
}
///定义一个 Action 类
///将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshTitleDataAction {
  final String title;
  RefreshTitleDataAction(this.title);
}
