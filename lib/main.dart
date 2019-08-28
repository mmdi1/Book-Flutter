import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/views/BottomNavigation/BottomNavigation.dart';
import 'package:thief_book_flutter/views/home/welcome_page.dart';

void main() {
  runApp(new FlutterReduxApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FlutterReduxApp extends StatelessWidget {
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<ReduxState>(
    appReducer,

    ///初始化数据
    initialState: new ReduxState(
        themeData: ThemeData(
            primarySwatch: Colors.blue, platform: TargetPlatform.android),
        progressData: "" //解析进度
        ),
    // locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<ReduxState>(builder: (context, store) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '首页',
            navigatorObservers: [routeObserver],
            home: new SplashScreen(store),
            // home: new BottomNavigationWidget(store),
            //主题
            theme: store.state.themeData,
          );
        }));
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: '首页',
//       navigatorObservers: [routeObserver],
//       // home: new SplashScreen(),
//       home: new BottomNavigationWidget(),
//       theme: ThemeData(
//           primarySwatch: Colors.yellow,
//           highlightColor: Color.fromRGBO(255, 255, 255, 0.5),
//           splashColor: Colors.white70),
//     );
//   }
// }
