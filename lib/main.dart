import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:thief_book_flutter/common/localization/default_localizations.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/views/BottomNavigation/BottomNavigation.dart';
import 'package:thief_book_flutter/views/home/welcome_page.dart';
import 'package:thief_book_flutter/views/reader/reader_screen.dart';

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
        themeData: ThemeData(primaryColor: Colors.white),
        progressData: "", //解析进度
        title: "当前1.8元/总共10.05元"),
    // locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<ReduxState>(builder: (context, store) {
          return new MaterialApp(
            // locale: Locale('en', 'US'),
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supportedLocales) {
              return locale;
            },
            localizationsDelegates: [
              /// 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,

              /// 注册我们的Delegate
              FZLocalizationDelegate.delegate
            ],
            supportedLocales: [
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
            ],

            /// 监听系统语言切换
            localeListResolutionCallback: (deviceLocale, supportedLocales) {
              print('deviceLocale: $deviceLocale');
              // 系统语言是英语： deviceLocale: [en_CN, en_CN, zh_Hans_CN]
              // 系统语言是中文： deviceLocale: [zh_CN, zh_Hans_CN, en_CN]
              print('supportedLocales: $supportedLocales');
            },
            initialRoute: "/",
            routes: {
              "/": (context) {
                print("welcome------router");
                store.state.platformLocale = Localizations.localeOf(context);
                return new SplashScreen(
                  store: store,
                );
              },
              "/home": (context) {
                print("home------router");
                return new BottomNavigationWidget(store);
              },
              "/redaer": (context) {
                print("+======================-------------------:跳转至阅读");
                return new ReaderScene();
              }
            },
            //   "/search": (context) {
            //     return new SearchSreenWidget();
            //   }
            // },
            debugShowCheckedModeBanner: false,
            title: "墨鱼阅读",
            navigatorObservers: [routeObserver],
            // home: new SearchSreenWidget(),
            // home: new SplashScreen(store: store),
            // home: new ReaderScene(isOlineRedaer: true),
            // home: new BottomNavigationWidget(store),
            // home: ListPage(),
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
