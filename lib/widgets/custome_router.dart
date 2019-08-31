/**
 * 通过自定义transitionsBuilder实现路由过渡动画
 *
 * 请切换不同注释分别查看
 */
import 'package:flutter/material.dart';

class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  CustomRoute(this.widget)
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            //淡出过渡路由
            // return FadeTransition(
            //     opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //         parent: animation, curve: Curves.fastOutSlowIn)),
            //     child: child,
            //     );

            //比例转换路由
            //  return ScaleTransition(
            //    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //        parent: animation, curve: Curves.fastOutSlowIn)),
            //    child: child,
            //    );

            //旋转+比例转换路由
//            return RotationTransition(
//              turns: Tween(begin: -1.0, end: 1.0).animate(CurvedAnimation(
//                  parent: animation, curve: Curves.fastOutSlowIn)),
//              child: ScaleTransition(
//                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//                    parent: animation, curve: Curves.fastOutSlowIn)),
//                child: child,
//              ),
//            );

            //幻灯片路由
            return SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.fastOutSlowIn)),
              child: child,
            );
          },
        );
}

class CustomFindInRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;

  //构造方法
  CustomFindInRoute(this.widget, this.milliseconds)
      : super(
            transitionDuration: Duration(milliseconds: milliseconds), //过渡时间
            pageBuilder: (
              //构造器
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animation1,
                  curve: Curves.fastOutSlowIn, //动画曲线
                )),
                child: child,
              );
            });
}
