// 提交订单
import 'package:Bidder/common/bidder_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ConfirmOrder extends StatefulWidget {
  Map<String, dynamic> info;
  ConfirmOrder({Key key, this.info}) : super(key: key);
  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> with WidgetsBindingObserver {
  int _payType = 2; // 支付类型1微信2支付
  bool payState = false;
  String _wxPayResult = '';
  String _aliResultStatus = '';

  // 创建 订单
  void _createChooseOrder() async {
    if (widget.info['orderId'] == '' ) {
      // 发送 创建订单 请求
      var res = await Api.getInstance().createChooseOrder( widget.info['addr_id'], widget.info['gid'], 1, widget.info['remarks']);
      // print(res);
      var code = res["code"] as String;
      if (code == "200") {
        // 创建订单成功 发送支付请求
        widget.info['orderId'] = res["data"][0]['order_id'];
        _payType == 1 ? _wechatPay(widget.info['orderId'] , widget.info['addr_id'], widget.info['remarks']) : _aliPay(widget.info['orderId'], widget.info['addr_id'], widget.info['remarks']);
      } else {
        Fluttertoast.showToast(msg: '生成订单失败');
      }
    } else {
      _payType == 1 ? _wechatPay(widget.info['orderId'] , widget.info['addr_id'], widget.info['remarks']) : _aliPay(widget.info['orderId'], widget.info['addr_id'], widget.info['remarks']);
    }
    
  }

  //  订单 详情
  void chooseOrderDetail() async {
    // 发送 创建订单 请求
    var res = await Api.getInstance().chooseOrderDetail(widget.info['orderId']);
    // print(res);
    var code = res["code"] as String;
    if (code == "200") {
      // 订单状态0待支付1已支付待发货2已发货待收货3完成
      var orderStatus  = res["data"]['order_status'];
       orderStatus  = '1';// 测试 支付 开发的时候 去掉
      if (orderStatus == '1') {
        payState = true;
        Fluttertoast.showToast(msg: '支付成功');
        //跳转至 订单详情
        // 带完成
        Navigator.of(context).pop();
      }
    }
    
  }

  void _wechatPay(String _orderid, String _addrid, String _remarks) async {
    // 发送  wechatPay 支付 请求 得到支付 sign
    var res = await Api.getInstance().wechatPay(_orderid, _addrid, _remarks);
    // print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var sign = res["data"];
      // print(res["data"]);
      // var result = await FlutterAlipay.pay(res["data"]);

      if (sign == null || sign.length == 0) {
        return;
      }
      //清空 微信支付状态
      _wxPayResult = '';
      fluwx.registerWxApi(
        appId: "wxd22f02d56dc27606",
        doOnAndroid: true,
        doOnIOS: true);
       var result = fluwx.isWeChatInstalled();

      fluwx.payWithWeChat(appId: res["data"]['appid'],
          partnerId: res["data"]['partnerid'],
          prepayId: res["data"]['prepayid'],
          packageValue: res["data"]['package'],
          nonceStr: res["data"]['noncestr'],
          timeStamp: int.parse(res["data"]['timestamp']),
          sign: res["data"]['sign'],
        ) .then((data) {
          // print("---》$data");

        }).catchError((e){
          Fluttertoast.showToast(msg: '支付失败, 未知错误');
        });

    } else {
      Fluttertoast.showToast(msg: '发送支付失败');
    }
  }

  Future<void> _aliPay(String _orderid, String _addrid, String _remarks) async {

    // 发送 alipay 支付 请求 得到支付 sign
    var res = await Api.getInstance().aliPay(_orderid, _addrid, _remarks);
    // print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var sign = res["data"];
      // var result = await FlutterAlipay.pay(res["data"]);

      if (sign == null || sign.length == 0) {
        return;
      }
      // 清空 支付宝支付状态
      _aliResultStatus = '';
      FlutterAlipay.pay(sign).then((payResult) async {
        // _payResult = payResult;
        /**
         * 9000 订单支付成功
          8000 正在处理中
          4000 订单支付失败
          6001 用户中途取消
          6002 网络连接出错
         */
        // print('>>>>>  ${payResult.toString()}');

        String payResultStatus = payResult.resultStatus;
        if (payResultStatus == '9000') {
          payState = true;
          Fluttertoast.showToast(msg: '支付成功');
          //跳转至 订单详情
          // 带完成
          // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orderId: _orderid)));
          Navigator.of(context).pop(widget.info['orderId']);
        } else if (payResultStatus == '6001') {
          Fluttertoast.showToast(msg: '支付取消');
        } else if (payResultStatus == '4000') {
          Fluttertoast.showToast(msg: '支付失败');
        } else if (payResultStatus == '6002') {
          Fluttertoast.showToast(msg: '网络出错');
        } else {
          Fluttertoast.showToast(msg: '未知错误');
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: '支付失败, 未知错误');
      });
      
    } else {
      Fluttertoast.showToast(msg: '发送支付失败');
    }
  }

  Container _amountContain() {
    return Container(
        width: double.infinity,
        // height: ScreenUtil().setHeight(125),
        decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromRGBO(211, 211, 211, 1), width: 1)),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setWidth(20)),
          child: Column(
            children: <Widget>[
              Text(
                "实付金额",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(65, 65, 65, 1)),
              ),
              Text(
                widget.info == null ? '' : widget.info['price'],
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(65, 65, 65, 1)),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加 生命周期观察者
    // 微信支付代码
    fluwx.responseFromPayment.listen((data) async {
      // print(data.errCode);
      _wxPayResult = "${data.errCode}";
      // print('_result_result  > ${data.errCode}       errStrerrStr  ${data.errStr}');
      if (_wxPayResult == '0') {
        payState = true;
        Fluttertoast.showToast(msg: '支付成功');
        //跳转至 订单详情
        // 带完成
        // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orderId: _orderId)));
        Navigator.of(context).pop(widget.info['orderId']);
      } else if(_wxPayResult == '-2') {
        Fluttertoast.showToast(msg: '支付取消');
      } else {
        Fluttertoast.showToast(msg: '未知错误');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        if(_payType == 2) return; // 支付宝支付 不用

        if(_wxPayResult != '') return;
        // 判断微信支付状态
        if(payState) return;
        else {
          // 发送 判断微信支付成功
          // print('发送 判断微信支付成功');
          chooseOrderDetail();
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
          
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // print(widget.info['addr']);
    // print(' mm' + widget.info['order_id']);
    // return Container();
    // print('_____ build _ConfirmOrderState');
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          leading: BackButton(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "支付",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        // resizeToAvoidBottomPadding: true,
        bottomNavigationBar: Container(
          child: GestureDetector(
            child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(60),
                color: Color.fromRGBO(65, 65, 65, 1),
                child: Center(
                  child: Text(
                    "确认支付",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: ScreenUtil().setSp(12)),
                  ),
                )),
            onTap: () {
              _createChooseOrder();
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            child: IntrinsicHeight(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 标题
                    // HeadView(title: '支付', backShow: true, msgShow: false),
                    // 金额内容
                    _amountContain(),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(40),
                            bottom: ScreenUtil().setWidth(15),
                            left: ScreenUtil().setWidth(30)),
                        // color: Colors.black,
                        child: Text(
                          "选择支付方式",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(65, 65, 65, 1)),
                        ),
                      ),
                    ),

                    Container(
                        width: double.infinity,
                        // height: ScreenUtil().setHeight(125),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(211, 211, 211, 1),
                                width: 1)),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(15),
                            right: ScreenUtil().setWidth(15)),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(20),
                              bottom: ScreenUtil().setWidth(30)),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  // print('支付宝');
                                  setState(() {
                                    _payType = 2;
                                  });
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
                                            "images/alipay.png",
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
                                              bottom:
                                                  ScreenUtil().setWidth(10)),
                                          decoration: UnderlineTabIndicator(
                                            borderSide: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFFD3D3D3),
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text("支付宝"),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: ScreenUtil()
                                                          .setWidth(20)),
                                                  alignment:
                                                      Alignment.centerRight,

                                                  // color: Colors.red,
                                                  child: Icon(_payType == 2
                                                      ? Icons.check_circle
                                                      : Icons
                                                          .check_circle_outline),
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
                                  setState(() {
                                    _payType = 1;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(17)),
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
                                            "images/wechatpay.png",
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
                                              bottom:
                                                  ScreenUtil().setWidth(10)),
                                          decoration: UnderlineTabIndicator(
                                            borderSide: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFFD3D3D3),
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text("微信支付"),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: ScreenUtil()
                                                          .setWidth(20)),
                                                  alignment:
                                                      Alignment.centerRight,

                                                  // color: Colors.red,
                                                  child: Icon(_payType == 1
                                                      ? Icons.check_circle
                                                      : Icons
                                                          .check_circle_outline),
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

                    //商品信息
                  ]),
            ),
          ),
        ));
  }
}
