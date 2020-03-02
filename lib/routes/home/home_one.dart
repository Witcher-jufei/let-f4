import 'package:Bidder/routes/information/Information.dart';
import 'package:Bidder/routes/search/searchresult.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common/bidder_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';

import 'select_buy.dart';

class HomeOne extends StatefulWidget {
  @override
  _HomeOneState createState() => _HomeOneState();
}

class _HomeOneState extends State<HomeOne> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('_HomeOneState ....');
    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      }, // 触摸收起键盘
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: TabBar(),
        ),
      ),
    );
  }
}

//顶部tabbar
class TabBar extends StatefulWidget {
  @override
  _TabBarState createState() {
    // 组件刷新
    return _TabBarState();
  }
}

class _TabBarState extends State<TabBar> {
  String hintHotText = "村上隆"; // 搜索 关键字
  String _msgNum = "0"; //消息数量
  _loadMsgNum() async {
    // 发送 登录 请求
    var res = await Api.getInstance().getMsgsNumByUid();
    var code = res["code"] as String;

    if (code == '10001' || code == '10002') {
      Fluttertoast.showToast(msg: '登录信息失效');
      // NavigatorManager.getInstance().pushNamedAndRemoveUntil('login');
      Navigator.of(context)
          .pushNamedAndRemoveUntil("login", ModalRoute.withName("login"));
    }

    if (code == "200") {
      var data = res["data"] as String;
      if (data.length > 0) {
        setState(() {
          _msgNum = res["data"];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMsgNum();
  }

  @override
  Widget build(BuildContext context) {
    print('build _TabBarState ....');
    return Column(
      children: <Widget>[
        // 搜索框
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15)),
          // padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
          // height: ScreenUtil().setHeight(95),
          color: Color.fromRGBO(249, 249, 249, 1),
          // color: Colors.red,

          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  // margin: EdgeInsets.only(right: ScreenUtil().setHeight(35)),
                  // color: Colors.blue,
                  // padding: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
                  // width: ScreenUtil().setWidth(310),
                  child: TextField(
                      enableInteractiveSelection: false,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        // isDense: true,
                        hintText: hintHotText,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromRGBO(168, 168, 168, 1),
                          width: 1,
                        )),

                        prefixIcon: Icon(
                          Icons.search,
                          color: Color.fromRGBO(168, 168, 168, 1),
                          size: ScreenUtil().setHeight(25),
                        ),

                        // contentPadding: EdgeInsets.all(1.0)
                        // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onSubmitted: (text) {
                        print(" 搜索 搜索");

                        //  Navigator.push(context,MaterialPageRoute(builder: (context)=>searchResult()));
                        FocusScope.of(context).requestFocus(FocusNode()); //回收键盘
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult(
                                      searchText:
                                          text == "" ? hintHotText : text,
                                    )));
                        
                      }),
                ),
              ),
              Container(
                  // color: Colors.green,
                  // alignment: Alignment.bottomRight,
                  child: GestureDetector(
                onTap: () {
                  print("msg num tap");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Information()));
                },
                child: _msgNum == "0"
                    ? Image.asset(
                        "images/msg.png",
                        width: ScreenUtil().setWidth(21),
                        height: ScreenUtil().setHeight(22),
                      )
                    : Badge(
                        badgeColor: Color(0xFF1A2BFF),
                        badgeContent: Text(_msgNum,
                            style: TextStyle(color: Colors.white)),
                        child: Image.asset(
                          "images/msg.png",
                          width: ScreenUtil().setWidth(21),
                          height: ScreenUtil().setHeight(24),
                        ),
                      ),
              )),
            ],
          ),
        ),

        //
        SelectBuy(),
      ],
    );
  }
}
