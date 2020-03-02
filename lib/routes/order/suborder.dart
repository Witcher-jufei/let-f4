// 提交订单
import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/common/stringutils.dart';
import 'package:Bidder/routes/addr/add_addr.dart';
import 'package:Bidder/routes/addr/addrlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'confirmorder.dart';

class SubOrder extends StatefulWidget {
  dynamic info;
  SubOrder({Key key, this.info}) : super(key: key);
  @override
  _SubOrderState createState() => _SubOrderState();
}

class _SubOrderState extends State<SubOrder> {
  var _remarksTEC = new TextEditingController();
  // 请求数据
  void _loadDefultAddr() async {
    // 发送 登录 请求
    var res = await Api.getInstance().getDefultAddr();
    // print(res);
    var code = res["code"] as String;
    if (code == "200") {
      setState(() {
          widget.info['addr'] = res["data"];
      });
    }
  }

  void _createChooseOrder() async {
    widget.info["remarks"] = _remarksTEC.text;
    var _info = {'orderId':'', 'addr_id':widget.info['addr']['id'], 'gid':widget.info['id'], 'price':widget.info['present_price'], 'remarks': _remarksTEC.text};
    var _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmOrder(info: _info)));
    if (_result != null) {
      Navigator.of(context).pop(_result);
    }
  }

  // 路由返回结果
  var _pushResult;
  GestureDetector _noneContain() {
    return GestureDetector(
      onTap: () async {
        // 打开新增 地址
        _pushResult = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddAddress()));
        print(_pushResult);
        //保存结果成功 更换 地址栏
        if(_pushResult != null) {
          widget.info['addr'] = _pushResult;
        }
      },
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(125),
        decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromRGBO(211, 211, 211, 1), width: 1)),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(29)),
                    height: ScreenUtil().setHeight(42),
                    child: Icon(Icons.add)),
                Container(
                  child: Text("添加地址"),
                )
              ],
            ))),
    );
  }

  GestureDetector _yesContain() {
    return GestureDetector(
      onTap: () async {
        // 打开地址 列表
        _pushResult = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddressList()));
        print(_pushResult);
        //保存结果成功 更换 地址栏
        if(_pushResult != null) {
          widget.info['addr'] = _pushResult;
        } else {
          //请求默认地址
          _loadDefultAddr();
        }
      },
      child: Container(
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
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15)),
          child: Row(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                    padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    bottom: ScreenUtil().setWidth(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "收货人：" + widget.info['addr']['name'],
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                    Container(
                      child: Text(
                        "电话：" + widget.info['addr']['tel'],
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                      child: Text(
                        StringUtils.getAddr(widget.info['addr']['area']) + widget.info['addr']['address'],
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(12)),
                      ),
                    ),
                  ],
                ),
              ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right),),
              ),

            ],
          ),
        )));
  }

  // String _getAddr(String areas) {
  //   String __area = '';
  //   List<String> _areas = areas.split(',');
  //   if (_areas.length > 0) {
  //     _areas = _areas[0].split('-');
  //     for (String _item in _areas) {
  //       __area = __area + _item;
  //     }
  //   }
  //   return __area;  
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent, //把appbar的背景色改成透明
      //         elevation: 0,//appbar的阴影
      //   title: new Text('提交订单', style: TextStyle(color: Colors.black),)),
        // resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          leading: BackButton(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "提交订单",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        bottomNavigationBar: Container(
          child: GestureDetector(
            child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(60),
                color: Color.fromRGBO(65, 65, 65, 1),
                child: Center(
                  child: Text(
                    "去支付",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: ScreenUtil().setSp(12)),
                  ),
                )),
            onTap: () {
              //创建订单
              _createChooseOrder();
            },
          ),
        ),
        body: SafeArea(
          child: widget.info == null
              ? Container()
              : Container(
                  // color: Colors.red,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // 触摸收起键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        // // 标题
                        // HeadView(title: '提交订单', backShow: true, msgShow: false),
                        // 内容

                        Container(
                          child: widget.info['addr']['id'] == ''
                              ? _noneContain()
                              : _yesContain(),
                        ),

                        //商品信息
                        Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(30),
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15)),
                          height: ScreenUtil().setHeight(380),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(211, 211, 211, 1),
                                  width: 1)),

                          child: Container(
                            color: Colors.white,
                            child: ListView(
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                Container(
                                  // color: Colors.red,
                                  margin: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(15),
                                    ScreenUtil().setHeight(10),
                                    ScreenUtil().setWidth(15),
                                    0,
                                  ),
                                  padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setHeight(18)),
                                  alignment: Alignment.centerLeft,
                                  decoration: new UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Color.fromRGBO(249, 249, 249, 1),
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //  卖家名称
                                            Container(
                                              color: Color.fromRGBO(
                                                  211, 243, 255, 1),
                                              child: Text(
                                                widget.info['business'],
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      18, 175, 234, 1),
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(12),
                                              ),
                                              // color: Colors.red,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: CachedNetworkImage(
                                                        height: ScreenUtil()
                                                            .setWidth(100),
                                                        imageUrl: widget
                                                            .info["image"][0],
                                                        placeholder: (context,
                                                                url) =>
                                                            Image.asset(
                                                                "images/app.png"),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                                "images/app.png"),
                                                      ),
                                                    ),
                                                    flex: 1,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      // color: Colors.blue,
                                                      margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(12),
                                              ),
                                                      child: IntrinsicHeight(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Text(
                                                                  widget.info['name'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(14))),
                                                              flex: 3,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                widget.info['present_price'],
                                                                style: TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                "x 1",
                                                                style: TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12)),
                                                              ),
                                                              flex: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 2,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //运费
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(15),
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setWidth(15),
                                      0),
                                  padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setHeight(10)),
                                  alignment: Alignment.centerLeft,
                                  decoration: new UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Color.fromRGBO(249, 249, 249, 1),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text("运费",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text("￥0",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(12))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 备注
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(15),
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setWidth(15),
                                      0),
                                  padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setHeight(10)),
                                  alignment: Alignment.centerLeft,
                                  decoration: new UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Color.fromRGBO(249, 249, 249, 1),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text("留言备注",style: TextStyle(fontSize:ScreenUtil().setSp(14))),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text("建议提前协商",
                                              style: TextStyle(
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize:
                                                      ScreenUtil().setSp(12))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(15),
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setWidth(15),
                                      0),
                                  padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setHeight(10)),
                                  alignment: Alignment.centerLeft,
                                  decoration: new UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Color.fromRGBO(249, 249, 249, 1),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _remarksTEC,
                                cursorColor: Colors.black,
                                maxLength: 100,
                                maxLines:2,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '选填，请和卖家协商一致',hintStyle:TextStyle(
                                      fontSize: ScreenUtil().setSp(12),
                                      color: Color.fromRGBO(168, 168, 168, 1)
                                    ) ),
                              ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
        ));
  }
}
