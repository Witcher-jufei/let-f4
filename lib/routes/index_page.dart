
import 'package:Bidder/routes/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'collection.dart';
import 'home/home_one.dart';
import 'news.dart';

class IndexRoute extends StatefulWidget {
  @override
  _IndexRouteState createState() => _IndexRouteState();
}

class _IndexRouteState extends State<IndexRoute> with SingleTickerProviderStateMixin {
  FocusNode blankNode=FocusNode();
  var appBartitles=['','','',''];//底部导航文字
  int _tabIndex = 0;
  var tabImages;
  var pages=[HomeOne(), Collection(), NewsRoute(), 
  UserInfoRoute(),
  // OrderView(orderId: '61'),
  // ChooseOrderList()
  ];//主页面
    Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return  Text(appBartitles[curIndex],
          style:  TextStyle(fontSize: 0.0, color: const Color(0xff1296db)));
    } else {
      return  Text(appBartitles[curIndex],
          style:  TextStyle(fontSize: 0.0, color: const Color(0xff515151)));
    }
    }
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }
  Image getTabImage(path) {
    return  Image.asset(path, width:ScreenUtil().setWidth(20.0), height: ScreenUtil().setHeight(25.0));
  }
  void initData(){
    tabImages = [//底部导航栏图片
      [getTabImage('images/home_slices/home.png'), getTabImage('images/home_slices/home-s.png')],
      [getTabImage('images/collection/collection.png'), getTabImage('images/collection/collection-s.png')],
      [getTabImage('images/news/news.png'), getTabImage('images/news/news-s.png')],
      [getTabImage('images/user/user.png'), getTabImage('images/user/user-s.png')],
    ];
  }
  @override
  Widget build(BuildContext context) {
    initData();
    return Scaffold(
        body:IndexedStack(
          index: _tabIndex,
          children:pages ,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: getTabIcon(0),title:getTabTitle(0)),
            BottomNavigationBarItem(
                icon: getTabIcon(1),title:getTabTitle(1)),
            BottomNavigationBarItem(
                icon: getTabIcon(2),title:getTabTitle(2)),
            BottomNavigationBarItem(
                icon: getTabIcon(3),title:getTabTitle(3)),
          ],
          type: BottomNavigationBarType.fixed,
          //默认选中首页
          currentIndex: _tabIndex,
          iconSize: 24.0,
          //点击事件
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ));
  }
}