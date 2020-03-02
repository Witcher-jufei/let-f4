import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/addr/edit_addr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_addr.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  // 消息数据源
  List<dynamic> _list = new List<dynamic>();
  // 加载 页数
  int page = 0;
  // 发送 选购列表  请求
  void _loadData() async {
    print(page);
    var res = await Api.getInstance().addressList();
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      setState(() {
          // gooslist = data;
          _list.addAll(data);
      });
      return;
    } else {
      setState(() {
          _list.clear(); 
      });
      
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Container _buildHead() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(88),
      color: Color.fromRGBO(249, 249, 249, 1),
      // color: Colors.red,
      child: Container(
        // color: Colors.blue,
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(15),
            left: ScreenUtil().setWidth(15),
            right: ScreenUtil().setWidth(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //返回按钮
            Expanded(
              child: Container(
                // color: Colors.green,
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  // color: Colors.white,
                  alignment: Alignment.center,
                  child: Text(
                    '收货地址',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )),
            ),
            // 消息
            Expanded(
              child: Container(
                  // color: Colors.green,
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      // 打开新增 地址
                      var _pushResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAddress()));
                      // print(_pushResult);
                      //保存结果成功 更换 地址栏
                      if (_pushResult != null) {
                        // widget.info['addr'] = _pushResult;
                        page = 1;
                        _list.clear();
                        _loadData();
                      }
                    },
                    child: Icon(Icons.add),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          leading: BackButton(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "收货地址",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () async {
                // 打开新增 地址
                var _pushResult = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAddress()));
                // print(_pushResult);
                //保存结果成功 更换 地址栏
                if (_pushResult != null) {
                  // widget.info['addr'] = _pushResult;
                  page = 1;
                  _list.clear();
                  _loadData();
                }
              }),
          ],
        ),
      body: SafeArea(
        top: true,
        child: Column(
          children: <Widget>[
            // 标题
            // _buildHead(),
            Expanded(
              child: Stack(children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                EasyRefresh.custom(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _Item(
                              listcontext: context, item: _list[index]);
                        }, childCount: _list.length),
                      ),
                    ),
                  ],
                  onRefresh: () async {
                    page = 1;
                    _list.clear();
                    _loadData();
                  },
                  onLoad: () async {
                    // page++;
                    // _loadData();
                  },
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class _Item extends StatefulWidget {
  final dynamic item;
  final BuildContext listcontext;
  const _Item({Key key, this.item, this.listcontext}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  

  // void _setDefault() async {
  //   // 发送 收藏 请求
  //   var res = await Api.getInstance().addrSetDefault(widget.item["id"]);
  //   var code = res["code"] as String;
  //   if (code == "200") {
  //     _AddressListState _state = widget.listcontext.findAncestorStateOfType<_AddressListState>();
  //     _state.page = 1;
  //     _state._list.clear();
  //     _state._loadData();
  //   }
  // }

  void _delAddress() async {
    // 发送 收藏 请求
    var res = await Api.getInstance().delAddress(widget.item["id"]);
    var code = res["code"] as String;
    if (code == "200") {
      Fluttertoast.showToast(msg: "删除成功");
      _AddressListState _state = widget.listcontext.findAncestorStateOfType<_AddressListState>();
      _state.page = 1;
      _state._list.clear();
      _state._loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    List _areas = widget.item['area'].split(',');
    String __area = '';

    if (_areas.length > 0) {
      _areas = (_areas[0] as String).split('-');

      for (String _item in _areas) {
        __area = __area + _item;
      }
    }

    return GestureDetector(
      onTap: () {
        print(widget.listcontext);
         Navigator.pop(context, widget.item);
      },
      child: Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setHeight(15),
          bottom: ScreenUtil().setHeight(20)),
      // padding: EdgeInsets.only(left: ScreenUtil().setWidth(15), right: ScreenUtil().setHeight(15)),

      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromRGBO(211, 211, 211, 1), width: 1)),
      child: Container(
        // color: Colors.red,
        margin: EdgeInsets.all(ScreenUtil().setHeight(15)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        "收货人：" + widget.item['name'],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "手机号码：" + widget.item['tel'],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding:
                            EdgeInsets.only(right: ScreenUtil().setHeight(6)),
                        child: Text(
                          __area + widget.item['address'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // GestureDetector(
                            //   onTap: () {
                            //     // if (widget.item['default']=='0') _setDefault();
                            //     print(widget.listcontext);

                            //   },
                            //   child: Container(
                            //   // color: Colors.red,
                            //     // padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                            //     alignment: Alignment.bottomLeft,
                            //     child: widget.item['default']=='1' ? Icon(Icons.check_circle) : Icon(Icons.check_circle_outline),
                            //   ),
                            // ),
                            Expanded(
                              flex: 1,
                              child: widget.item['default'] == '1'
                                  ? Row(
                                      children: <Widget>[
                                        Container(
                                          // color: Colors.red,
                                          padding: EdgeInsets.only(
                                              right:
                                                  ScreenUtil().setHeight(10)),
                                          alignment: Alignment.bottomLeft,
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 20,
                                          ),
                                        ),
                                        Text(
                                          "默认地址",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(14),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(),
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setHeight(10)),
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(25),
                              child: RaisedButton(
                                color: Color(0xFF414141),
                                child: Text(
                                  "删除",
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                                onPressed: () {
                                  _delAddress();
                                },
                              ),
                            ),

                            Container(
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(25),
                              child: RaisedButton(
                                color: Color(0xFF414141),
                                child: Text(
                                  "编辑",
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditAddress(info: widget.item,)));
                                  // print(_pushResult);
                                  //保存结果成功 更换 地址栏
                                  _AddressListState _state = widget.listcontext.findAncestorStateOfType<_AddressListState>();
                                    _state.page = 1;
                                    _state._list.clear();
                                    _state._loadData();
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    )
    );
    
  }
}
