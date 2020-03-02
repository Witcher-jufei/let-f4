import 'dart:async';

import 'package:Bidder/common/stringutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import '../common/global.dart';

import '../common/bidder_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;

class LoginRoute extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginRoute> {
  bool checkselect = false; // 协议 勾选
  bool isverifyhBtnDisabled = true; // 验证码按钮 可用
  String buttonText = '获取验证码'; //初始文本
  int count = 5; //初始倒计时时间
  Timer timer; //倒计时的计时器

  WidgetsBinding widgetsBinding;

  final _vtelController = TextEditingController();
  final _vcodeController = TextEditingController();

  // 点击验证码 按钮
  void _verifyhOnPressed() async {
    if (isverifyhBtnDisabled) {
      // 发送 验证码 请求
      var res = await Api.getInstance().verify(_vtelController.text);
      print(res);
      var code = res["code"] as String;
      var msg = res["msg"] as String;
      if (code == "200") {
        Fluttertoast.showToast(msg: "验证码已发送");
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    }

    setState(() {
      if (isverifyhBtnDisabled) {
        // print(_vtelController.text);
        isverifyhBtnDisabled = false; //按钮状态标记
        _initTimer();
        return null;
      } else {
        return null;
      }
    });
  }

  //倒计时方法
  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isverifyhBtnDisabled = true; //按钮可点击
          count = 5; //重置时间
          buttonText = '获取验证码'; //重置按钮文本
        } else {
          buttonText = '重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  // 协议点击
  void _textClick() {
    // print('text click');
    Navigator.pushNamed(context, "agreement");
  }

  _loginPressed() async {
    //手机号验证
    if (!StringUtils.isChinaPhoneLegal(_vtelController.text)) {
      Fluttertoast.showToast(msg: "请输入正确的手机号");
      return;
    }
    //验证码验证
    if (_vcodeController.text == "") {
      Fluttertoast.showToast(msg: "请输入验证码");
      return;
    }

    // 发送 登录 请求
    var res = await Api.getInstance()
        .login(_vtelController.text, _vcodeController.text);
    // print(res);
    var code = res["code"] as String;
    var msg = res["msg"] as String;
    if (code == "200") {
      Fluttertoast.showToast(msg: "登录成功");
      //更新profile中的token信息
      Global.token = res["data"][0]["token"];
      Global.saveProfile();
      Navigator.pushNamed(context, "index");
    } else {
      Fluttertoast.showToast(msg: msg);
    }
  }

  @override
  void initState() {
    super.initState();
    widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      print("addPostFrameCallback be invoke");
      _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   color: Color.fromRGBO(249, 250, 249, 1.0),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
            
      //                 Container(
      //                     margin: EdgeInsets.only(
      //                       bottom: ScreenUtil().setHeight(44),
      //                     ),
      //                     child: Row(
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: <Widget>[
      //                         Center(
      //                           child: InkWell(
      //                             onTap: () {
      //                               setState(() {
      //                                 checkselect = !checkselect;
      //                               });
      //                             },
      //                             child: checkselect
      //                                 ? Icon(
      //                                     Icons.check_circle,
      //                                     size: 20.0,
      //                                     color: Colors.black,
      //                                   )
      //                                 : Icon(
      //                                     Icons.check_circle_outline,
      //                                     size: 20.0,
      //                                     color: Colors.black,
      //                                   ),
      //                           ),
      //                         ),
      //                         Container(
      //                           margin: EdgeInsets.only(
      //                             left: ScreenUtil().setHeight(10),
      //                           ),
      //                           child: Text("我已阅读并同意",
      //                               style: TextStyle(fontSize: 14.0)),
      //                         ),
      //                         Container(
      //                           child: GestureDetector(
      //                             child: Text("《用户协议》",
      //                                 style: TextStyle(
      //                                     color: Colors.blue, fontSize: 14.0)),
      //                             onTap: this._textClick,
      //                           ),
      //                         ),
      //                         Container(
      //                           child:
      //                               Text("和", style: TextStyle(fontSize: 14.0)),
      //                         ),
      //                         Container(
      //                           child: GestureDetector(
      //                             child: Text("《隐私政策》",
      //                                 style: TextStyle(
      //                                     color: Colors.blue, fontSize: 14.0)),
      //                             onTap: () {
      //                               Navigator.pushNamed(context, "privacy");
      //                             },
      //                           ),
      //                         ),
      //                       ],
      //                     )),
      //       Container(
      //                   width: ScreenUtil().setHeight(302),
      //                   margin:
      //                       EdgeInsets.only(bottom: ScreenUtil().setHeight(58)),
      //                   // alignment: Alignment.center,
      //                   child: RaisedButton(
      //                     color: Color(0xFF414141),
      //                     child: Text(
      //                       "登录",
      //                       style:
      //                           TextStyle(color: Colors.white, fontSize: 12.0),
      //                     ),
      //                     onPressed: checkselect ? _loginPressed : null,
      //                   ),
      //                 )         
      //     ],
      //   ),
      // ),
     
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 0),
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(100),
                          bottom: ScreenUtil().setWidth(105),
                        ),
                        child: Image.asset(
                          "images/login_Logo.png",
                          width: ScreenUtil().setWidth(203),
                          height: ScreenUtil().setHeight(141),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(32),
                            right: ScreenUtil().setWidth(32)),
                        child: TextField(
                          controller: _vtelController,
                          keyboardType: TextInputType.number, //键盘类型，数字键盘
                          cursorColor: Colors.black,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.black), //输入文本的样式
                          decoration: InputDecoration(hintText: "请输入手机号"),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly, //只输入数字
                            LengthLimitingTextInputFormatter(21) //限制长度
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(30),
                            left: ScreenUtil().setWidth(32),
                            right: ScreenUtil().setWidth(32)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: TextField(
                                  controller: _vcodeController,
                                  keyboardType:
                                      TextInputType.number, //键盘类型，数字键盘
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black), //输入文本的样式
                                  decoration:
                                      InputDecoration(hintText: "输入验证码"),
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter
                                        .digitsOnly, //只输入数字
                                    LengthLimitingTextInputFormatter(4) //限制长度
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0xFFD3D3D3),
                                    disabledTextColor: Colors.white,
                                    textColor: Colors.white, //文本颜色
                                    color: isverifyhBtnDisabled
                                        ? Color(0xFF414141)
                                        : Color(0xFFD3D3D3),
                                    child: Text(
                                      '$buttonText',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    ),
                                    onPressed: _verifyhOnPressed,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(158),
                          ),
                          // color: Colors.red,
                          // height: ScreenUtil().setHeight(20),
                          // padding:EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      checkselect = !checkselect;
                                    });
                                  },
                                  child: checkselect
                                      ? Icon(
                                          Icons.check_circle,
                                          size: 20.0,
                                          color: Colors.black,
                                        )
                                      : Icon(
                                          Icons.check_circle_outline,
                                          size: 20.0,
                                          color: Colors.black,
                                        ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setHeight(10),
                                ),
                                child: Text("我已阅读并同意",
                                    style: TextStyle(fontSize: 14.0)),
                              ),
                              Container(
                                child: GestureDetector(
                                  child: Text("《用户协议》",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 14.0)),
                                  onTap: this._textClick,
                                ),
                              ),
                              Container(
                                child:
                                    Text("和", style: TextStyle(fontSize: 14.0)),
                              ),
                              Container(
                                child: GestureDetector(
                                  child: Text("《隐私政策》",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 14.0)),
                                  onTap: () {
                                    Navigator.pushNamed(context, "privacy");
                                  },
                                ),
                              ),
                            ],
                          )),
                      Center(
                          child: Container(
                        // color: Colors.red,
                        width: ScreenUtil().setHeight(302),
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(44)),
                        // alignment: Alignment.center,
                        child: RaisedButton(
                          color: Color(0xFF414141),
                          child: Text(
                            "登录",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          onPressed: checkselect ? _loginPressed : null,
                        ),
                      )),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }

    _vtelController.dispose();
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("用户协议与隐私政策"),
          content: Container(
            margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),),
            alignment: Alignment.centerLeft,
            child: Text(
            "感谢您的选择！我们非常重视您的个人信息和隐保护。在使用我们的服务前，请认真阅读《用户协议》和《隐私政策》。我们将通过上述协议向您说明，我们将如何为您提供服务。如果您同意，请点击“同意”继续使用。",
            style: TextStyle(fontSize: 16),
          ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("不同意"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text("同意"),
              onPressed: () async {
                setState(() {
                  checkselect = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
