import 'package:flutter/material.dart';
import 'package:thief_book_flutter/views/BottomNavigation/BottomNavigation.dart';

class SplashScreen extends StatefulWidget {
  var store;
  SplashScreen(this.store);
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  //with是dart的关键字，意思是混入的意思，就是说可以将一个或者多个类的功能添加到自己的类无需继承这些类，避免多重继承导致的问题。可以在https://stackoverflow.com/questions/21682714/with-keyword-in-dart中找到答案
  //为什么是SingleTickerProviderStateMixin呢，因为初始化animationController的时候需要一个TickerProvider类型的参数Vsync参数，所以我们混入了TickerProvider的子类SingleTickerProviderStateMixin

  AnimationController _controller; //该对象管理着animation对象
  Animation _animation; //该对象是当前动画的状态，例如动画是否开始，停止，前进，后退。

  //初始化动画
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    /*动画事件监听器，
    它可以监听到动画的执行状态，
    我们这里只监听动画是否结束，
    如果结束则执行页面跳转动作,跳转到home界面。 */
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (route) => route == null);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             BottomNavigationWidget(this.widget.store)),
        //     (route) => route == null);
      }
    });
    //播放动画
    _controller.forward();
  }

  //销毁生命周期
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //透明度动画组件
    return FadeTransition(
      opacity: _animation, //执行动画
      child: Image.network(
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565625853431&di=074322e4694e662d371c60743e16784d&imgtype=0&src=http%3A%2F%2Fupload.taihainet.com%2Fnews%2FUploadFiles_6334%2F201312%2F20131226073319201_m.jpg',
          scale: 2.0, //图片缩放
          fit: BoxFit.cover // 充满父容器
          ),
    );
  }
}
