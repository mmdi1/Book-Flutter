import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      timeInSecForIos: 2,
      gravity: ToastGravity.CENTER,
    );
  }
}
