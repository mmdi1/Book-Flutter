import 'package:flutter/material.dart';
import 'package:thief_book_flutter/views/BottomNavigation/BottomNavigation.dart';
import 'package:thief_book_flutter/views/home/welcome_page.dart';

void main() {
  runApp(new MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '首页',
      navigatorObservers: [routeObserver],
      home: new SplashScreen(),
      // home: new BottomNavigationWidget(),
      theme: ThemeData(
          primarySwatch: Colors.yellow,
          highlightColor: Color.fromRGBO(255, 255, 255, 0.5),
          splashColor: Colors.white70),
    );
  }
}
