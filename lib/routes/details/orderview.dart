import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/common/stringutils.dart';
import 'package:Bidder/routes/order/confirmorder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';


class OrderView extends StatefulWidget {
  final String orderId;
  const OrderView({Key key, this.orderId}) : super(key: key);
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  // 请求数据
  dynamic _info;
  void _loadOrderInfo() async {
    // 发送 登录 请求
    var res = await Api.getInstance().chooseOrderDetail(widget.orderId);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      setState(() {
        _info = res["data"];
      });
    }
  }

      // 发送 确认订单  请求
  void _confirmOrder(String orderId) async {
    var res = await Api.getInstance().confirmOrder(orderId);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      Fluttertoast.showToast(msg: '确认收货成功');
      Navigator.of(context).pop(orderId);
    }
  }

  Container _yesContain() {
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                      bottom: ScreenUtil().setWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "收货人：" + _info['address']['name'],
                          style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                        ),
                      ),
                      Container(
                        child: Text(
                          "电话：" + _info['address']['tel'],
                          style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                        child: Text(
                          StringUtils.getAddr(_info['address']['area']) +
                              _info['address']['address'],
                          style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _loadOrderInfo();
  }

  //不同 状态 显示 不同的 组件
  Widget _showStatusWidget() {
    Widget _w;
    switch(_info['order_status']) {
      case '0':
        _w = new Container(
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setHeight(30),
            child: FlatButton(
                textColor: Colors.white, //文本颜色
                color: Color(0xFF414141),
                child: Text('支付', style: TextStyle(fontSize: 12),),
                onPressed: () async {
                  var __info = {'orderId':_info['id'], 'addr_id': _info['address']['id'], 'gid': _info['good']['id'], 'price': _info['format_price'], 'remarks': _info['remarks']};
                  var _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmOrder(info: __info)));
                  if (_result != null) {
                    Navigator.of(context).pop(_result);
                  }

                }));
      break;
      case '1':
        _w = new Text('待发货', style: TextStyle(fontSize: 12, color: Color(0xFF414141)));
      break;
      case '2':
        _w = new Container(
            color: Colors.red,
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(30),
            child: FlatButton(
                textColor: Colors.white, //文本颜色
                color: Color(0xFF414141),
                child: Text('确认收货', style: TextStyle(fontSize: 12),),
                onPressed: () {
                  _confirmOrder(_info['id']);
                }));
      break;
      case '3':
        _w = new Text('已完成', style: TextStyle(fontSize: 12, color: Color(0xFF414141)));
      break;
      default:
        _w = new Text('未知', style: TextStyle(fontSize: 12, color: Color(0xFF414141)));
    }
    return _w;
  }

  @override
  Widget build(BuildContext context) {
    // print(_info);
    return Scaffold(
        // appBar: HeadView(),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          leading: BackButton(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "订单详情",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        // bottomNavigationBar: _buildBottomNavigationBar(),
        body: SafeArea(
          child: _info == null
              ? Container(
                  color: Colors.white,
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      // height: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Container(
                            child: _yesContain(),
                          ),

                          // // 商品信息
                          Container(
                            // color: Colors.red,
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setWidth(15),
                                right: ScreenUtil().setWidth(15)),
                            // height: ScreenUtil().setHeight(400),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(211, 211, 211, 1),
                                    width: 1)),

                            child: Container(
                              color: Colors.white,
                              child: Column(
                                // ListView(
                                //   shrinkWrap: true,
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
                                                  _info['good']['business'],
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
                                                  top:ScreenUtil().setWidth(12),
                                                ),
                                                // color: Colors.red,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        // color: Colors.red,
                                                        alignment: Alignment.centerLeft,
                                                        child:CachedNetworkImage(
                                                          height: ScreenUtil().setWidth(100),
                                                          imageUrl: _info['good']["coverimage"],
                                                          placeholder: (context,url) => Image.asset("images/app.png"),
                                                          errorWidget: (context, url, error) =>  Image.asset( "images/app.png"),
                                                        ),
                                                      ),
                                                      flex: 1,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        // color: Colors.blue,
                                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(12),),
                                                        child: IntrinsicHeight(
                                                          child: Container(
                                                            child:Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:Container(
                                                                  height: double.infinity,
                                                                  // color: Colors.red,
                                                                  padding:EdgeInsets.only(
                                                                    bottom: ScreenUtil().setWidth(20),
                                                                  ),
                                                                  child: Text(_info['good']['name'],
                                                                      style: TextStyle(fontSize:ScreenUtil().setSp(14))),
                                                                ),
                                                                flex: 1,
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      _info['good']['present_price'],
                                                                      style: TextStyle(fontSize: ScreenUtil().setSp(12),
                                                                          fontWeight:FontWeight.w300),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                        left: ScreenUtil()
                                                                            .setWidth(80),
                                                                      ),
                                                                      child: _showStatusWidget(),
                                                                    )
                                                                  ],
                                                                ),
                                                                flex: 1,
                                                              ),
                                                            ],
                                                          ),
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
                                            child: Text('¥0',
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(12))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //实付款
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
                                          child: Text("实付款（含运费）",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(14))),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(_info['format_price'],
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(12))),
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
                                          child: Text("留言备注",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(14))),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('',
                                                style: TextStyle(
                                                    color: Color(0xFFA8A8A8),
                                                    fontSize: ScreenUtil()
                                                        .setSp(12))),
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
                                    child: Text(
                                      _info['remarks'],
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //  订单信息
                          Container(
                              width: double.infinity,
                              // height: ScreenUtil().setHeight(125),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(211, 211, 211, 1),
                                      width: 1)),
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(30),
                                  bottom: ScreenUtil().setHeight(30),
                                  left: ScreenUtil().setWidth(15),
                                  right: ScreenUtil().setWidth(15)),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(15),
                                    right: ScreenUtil().setWidth(15)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20),
                                      bottom: ScreenUtil().setWidth(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "订单编号：" + _info['order_num'],
                                          style: TextStyle(
                                              color: Color(0xFFA8A8A8)),
                                        ),
                                      ),
                                       _info['pay_num'] != ''
                                      ?Container(
                                        child: Text(
                                          "交易流水号：" + _info['pay_num'],
                                          style: TextStyle(
                                              color: Color(0xFFA8A8A8)),
                                        ),
                                      ):Container(),
                                      Container(
                                        child: Text(
                                          '创建时间：' + _info['created_at'],
                                          style: TextStyle(
                                              color: Color(0xFFA8A8A8)),
                                        ),
                                      ),
                                      _info['express'] != ''
                                      ? Container(
                                        child: Text(
                                          '承运快递：' + _info['express'],
                                          style: TextStyle(
                                              color: Color(0xFFA8A8A8)),
                                        ),
                                      ) : Container(),
                                      _info['express_num'] != ''
                                      ? Container(
                                        child: Text(
                                          '快递单号：' + _info['express_num'],
                                          style: TextStyle(
                                              color: Color(0xFFA8A8A8)),
                                        ),
                                      ): Container(),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),

          // Column(
          //     children: <Widget>[

          //     ],
          //   ),
        ),
      );
  }
}
