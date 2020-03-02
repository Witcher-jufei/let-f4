import 'package:Bidder/routes/addr/addrlist.dart';
import 'package:Bidder/routes/details/personalview.dart';
import 'package:Bidder/routes/order/orderlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'common/global.dart';
import 'common/profile_change_notifier.dart';
import 'routes/index_page.dart';
import 'routes/login.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  Global.init().then((e) => runApp(MyApp()));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: Consumer<UserModel>(
        builder: (context, counter, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // navigatorObservers: [NavigatorManager.getInstance()],
            title: 'Bidder',
            theme: new ThemeData(
              primaryColor:Colors.black
            ),
            home: _Main(),
            // 注册路由表
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "index": (context) => IndexRoute(),
              "addrlist": (context) => AddressList(),
              "orderlist": (context) => ChooseOrderList(),
              'personalview' :(context) => PersonalView(),

              "agreement": (_) => new WebviewScaffold(
                url: "https://bidder.artcare.com/H5/agreement.html",
                appBar: new AppBar(
                  brightness: Brightness.light,
                  backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                  leading: BackButton(color: Colors.black),
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "用户协议",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),

              "privacy": (_) => new WebviewScaffold(
                url: "https://bidder.artcare.com/H5/privacy.html",
                appBar: new AppBar(
                  brightness: Brightness.light,
                  backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                  leading: BackButton(color: Colors.black),
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "隐私政策",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),

              "qa": (_) => new WebviewScaffold(
                url: "https://bidder.artcare.com/H5/qa.html",
                appBar: new AppBar(
                  brightness: Brightness.light,
                  backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                  leading: BackButton(color: Colors.black),
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "常见问题",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),

              "about": (_) => new WebviewScaffold(
                url: "https://bidder.artcare.com/H5/about.html",
                appBar: new AppBar(
                  brightness: Brightness.light,
                  backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                  leading: BackButton(color: Colors.black),
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "关于我们",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            },
          );
        }
      ),
    );
  }

}

class _Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<_Main> {
  @override
  Widget build(BuildContext context) {
    //If you want to set the font size is scaled according to the system's "font size" assist option
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);

    return Global.token == '' ? LoginRoute() : IndexRoute();
  }
}
