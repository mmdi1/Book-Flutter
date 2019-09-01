import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/views/BottomNavigation/BottomNavigation.dart';
import 'package:thief_book_flutter/views/home/welcome_page.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';
import 'package:thief_book_flutter/views/search/search_screen.dart';

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
        themeData: ThemeData(primarySwatch: Colors.blue),
        progressData: "", //解析进度
        title: "书架"),
    // locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<ReduxState>(builder: (context, store) {
          return new MaterialApp(
            // initialRoute: "/search",
            // routes: {
            //   "/": (context) {
            //     print("welcome------router");
            //     store.state.platformLocale = Localizations.localeOf(context);
            //     return new SplashScreen(
            //       store: store,
            //     );
            //   },
            //   "/home": (context) {
            //     print("home------router");
            //     return new BottomNavigationWidget(store);
            //   },
            //   "/search": (context) {
            //     return new SearchSreenWidget();
            //   }
            // },
            debugShowCheckedModeBanner: false,
            title: "鱼叉阅读",
            navigatorObservers: [routeObserver],
            home: new SearchSreenWidget(),
            // home: new ReaderScene(isOlineRedaer: true),
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
