import 'package:redux/redux.dart';

///通过 flutter_redux 的 combineReducers，实现 Reducer 方法
final ProgressDataReducer = combineReducers<String>([
  ///将 Action 、处理 Action 的方法、State 绑定
  TypedReducer<String, RefreshProgressDataAction>(_refresh),
]);

///定义处理 Action 行为的方法，返回新的 State
String _refresh(String progressNum, action) {
  progressNum = action.progressNum;
  return progressNum;
}

///定义一个 Action 类
///将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshProgressDataAction {
  final String progressNum;

  RefreshProgressDataAction(this.progressNum);
}
