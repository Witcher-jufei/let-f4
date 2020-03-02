import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/common/global.dart';
import 'package:Bidder/routes/details/personalview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoRoute extends StatefulWidget {
  UserInfoRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserInfoRouteState createState() => new _UserInfoRouteState();
}

class _UserInfoRouteState extends State<UserInfoRoute> {
  // 发送 收藏列表  请求
  dynamic info;
  void _loadData() async {
    var res = await Api.getInstance().userinfo();
    var code = res["code"] as String;
    if (code == '10001' || code == '10002') {
      Fluttertoast.showToast(msg: '登录信息失效');
    }
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          info = data[0];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // print(info);
    return new Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        leading: Container(),
        // leading: BackButton(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "我的",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      body: info == null
          ? Center()
          : new Center(
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // 头像
                  GestureDetector(
                    onTap: () async {
                      var _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalView(info: info)));
                      _loadData();
                    },
                    child: Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(15),
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(15)),
                    child: Row(
                      children: <Widget>[
                        
                        Container(
                              // height: ScreenUtil().setWidth(80),
                              // 圆形图片
                              width: ScreenUtil().setHeight(120),
                              height: ScreenUtil().setHeight(120),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: info["pic"],
                                  placeholder: (context, url) =>
                                      Image.asset("images/app.png"),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("images/app.png"),
                                ),
                              ),
                            ),

                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(17)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  info['name'] == '' ? 'Bidder' : info['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(18),
                                  ),
                                ),
                                Text("点击编辑资料",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: ScreenUtil().setSp(12),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),


                  /////
                  Container(
                      width: double.infinity,
                      // height: ScreenUtil().setHeight(125),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(211, 211, 211, 1),
                              width: 1)),
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                          left: ScreenUtil().setWidth(15),
                          right: ScreenUtil().setWidth(15)),
                      child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'orderlist');
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(20)),
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        // color: Colors.blue,
                                        // padding: EdgeInsets.only(
                                        //   bottom: ScreenUtil().setWidth(20)),
                                        child: Image.asset(
                                          "images/order.png",
                                          width: ScreenUtil().setWidth(23),
                                          height: ScreenUtil().setHeight(23),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20)),
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(10)),
                                        decoration: UnderlineTabIndicator(
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFD3D3D3),
                                          ),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text('选购订单'),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(20)),
                                                alignment:
                                                    Alignment.centerRight,

                                                // color: Colors.red,
                                                child:
                                                    Icon(Icons.chevron_right),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // print('weixin');
                                Navigator.pushNamed(context, 'addrlist');
                              },
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10),
                                          left: ScreenUtil().setWidth(20)),
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        // color: Colors.blue,
                                        // padding: EdgeInsets.only(
                                        //   bottom: ScreenUtil().setWidth(20)),
                                        child: Image.asset(
                                          "images/addr.png",
                                          width: ScreenUtil().setWidth(23),
                                          height: ScreenUtil().setHeight(23),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10),
                                            left: ScreenUtil().setWidth(20)),
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(10)),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text('收货地址'),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(20)),
                                                alignment:
                                                    Alignment.centerRight,

                                                // color: Colors.red,
                                                child:
                                                    Icon(Icons.chevron_right),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  ///
                  Container(
                      width: double.infinity,
                      // height: ScreenUtil().setHeight(125),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(211, 211, 211, 1),
                              width: 1)),
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                          left: ScreenUtil().setWidth(15),
                          right: ScreenUtil().setWidth(15)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, "qa");
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10),
                                          left: ScreenUtil().setWidth(20)),
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        // color: Colors.blue,
                                        // padding: EdgeInsets.only(
                                        //   bottom: ScreenUtil().setWidth(20)),
                                        child: Image.asset(
                                          "images/wenti.png",
                                          width: ScreenUtil().setWidth(23),
                                          height: ScreenUtil().setHeight(23),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20)),
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(10)),
                                        decoration: UnderlineTabIndicator(
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFD3D3D3),
                                          ),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text('常见问题'),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(20)),
                                                alignment:
                                                    Alignment.centerRight,

                                                // color: Colors.red,
                                                child:
                                                    Icon(Icons.chevron_right),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, "about");
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10),
                                          left: ScreenUtil().setWidth(20)),
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        // color: Colors.blue,
                                        // padding: EdgeInsets.only(
                                        //   bottom: ScreenUtil().setWidth(20)),
                                        child: Image.asset(
                                          "images/about.png",
                                          width: ScreenUtil().setWidth(23),
                                          height: ScreenUtil().setHeight(23),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10),
                                            left: ScreenUtil().setWidth(20)),
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(10)),
                                        decoration: UnderlineTabIndicator(
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFD3D3D3),
                                          ),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text('关于我们'),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(20)),
                                                alignment:
                                                    Alignment.centerRight,

                                                // color: Colors.red,
                                                child:
                                                    Icon(Icons.chevron_right),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {

                                showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      // title: Text("这是一个iOS风格的对话框"),
                                      content: Text("400 101 2080", style: TextStyle(fontSize: 20),),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text("取消"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text("拨打"),
                                          onPressed: () async {
                                            const url = 'tel:4001012080';
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },);


                                
                              },
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10),
                                          left: ScreenUtil().setWidth(20)),
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        // color: Colors.blue,
                                        // padding: EdgeInsets.only(
                                        //   bottom: ScreenUtil().setWidth(20)),
                                        child: Image.asset(
                                          "images/kefu.png",
                                          width: ScreenUtil().setWidth(23),
                                          height: ScreenUtil().setHeight(23),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10),
                                            left: ScreenUtil().setWidth(20)),
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(10)),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text('联系我们'),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(20)),
                                                alignment:
                                                    Alignment.centerRight,

                                                // color: Colors.red,
                                                child:
                                                    Icon(Icons.chevron_right),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(48),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(211, 211, 211, 1), width: 1)),
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30),
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(15)),
                    child: GestureDetector(
                      onTap: () {
                        //
                        Global.token == '';
                        Navigator.of(context).pushNamedAndRemoveUntil("login", ModalRoute.withName("login"));
                      },
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text('退出登录', style: TextStyle(fontSize: 12),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
