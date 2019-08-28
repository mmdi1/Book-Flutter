import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:thief_book_flutter/common/redux/init_state.dart';
import 'package:thief_book_flutter/common/redux/theme_redux.dart';
import 'package:thief_book_flutter/widgets/progress_dialog.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DiscoveryPageState();
  }
}

class DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //测试主题颜色切换
  setColorTest(store) {
    ThemeData themeData =
        ThemeData(primarySwatch: Colors.red, platform: TargetPlatform.android);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new StoreBuilder<ReduxState>(
        builder: (context, store) {
          return new Scaffold(
            body: Container(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      '登录',
                      style: Theme.of(context).primaryTextTheme.headline,
                    ),
                    color: Colors.black,
                    onPressed: () {
                      setColorTest(store);
                      // ProgressDialog.showLoadingDialog(context, '登录中...');
                      //  Navigator.of(context).pop();
                    },
                  ),
                  Center(
                      child: Icon(Icons.change_history,
                          size: 128.0, color: Colors.black12))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
