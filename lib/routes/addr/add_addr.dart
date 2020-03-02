import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/common/stringutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _vnameController = TextEditingController();
  final _vtelController = TextEditingController();
  final _vareaController = TextEditingController();
  final _vaddrController = TextEditingController();
  bool _isDefault = true;
  String _area = '';
  String _areaId = '';

  //所选地区
  Result result;

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
            "添加地址",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      body: SafeArea(
          top: true,
          child: Container(
              // color: Colors.red,
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                // 标题
                // HeadView(title: '添加地址', backShow: true, msgShow: false),

                //地址信息
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(
                      // top: ScreenUtil().setHeight(300),
                      left: ScreenUtil().setWidth(15),
                      right: ScreenUtil().setWidth(15)),
                  height: ScreenUtil().setHeight(300),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(211, 211, 211, 1), width: 1)),
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        // 收货人
                        Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),
                              0, ScreenUtil().setWidth(20), 0),
                          // padding:EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                          // alignment: Alignment.centerLeft,
                          decoration: new UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Color.fromRGBO(249, 249, 249, 1),
                            ),
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("联系人",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(14))),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: TextField(
                                    controller: _vnameController,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '请输入收件人姓名',
                                        hintStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(12),
                                            color: Color.fromRGBO(
                                                168, 168, 168, 1))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        // 手机号码
                        Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),
                              0, ScreenUtil().setWidth(20), 0),
                          // padding:EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                          // alignment: Alignment.centerLeft,
                          decoration: new UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Color.fromRGBO(249, 249, 249, 1),
                            ),
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("手机号码",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12))),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: TextField(
                                    controller: _vtelController,
                                    cursorColor: Colors.black,
                                    keyboardType:
                                        TextInputType.number, //键盘类型，数字键盘
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter
                                          .digitsOnly, //只输入数字
                                      LengthLimitingTextInputFormatter(
                                          21) //限制长度
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '请输入手机号码',
                                      hintStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          color:
                                              Color.fromRGBO(168, 168, 168, 1)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        // 所在地区
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(20),
                                0,
                                ScreenUtil().setWidth(20),
                                0),
                            // padding:EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                            // alignment: Alignment.centerLeft,
                            decoration: new UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(249, 249, 249, 1),
                              ),
                            ),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text("所在地区",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(12))),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    // color:Colors.red,
                                    child: TextField(
                                      controller: _vareaController,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                      ),
                                      enabled: false,
                                      cursorColor: Colors.black,
                                      keyboardType:
                                          TextInputType.number, //键盘类型，数字键盘
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly, //只输入数字
                                        LengthLimitingTextInputFormatter(
                                            21) //限制长度
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '选择所在的地区',
                                        hintStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(12),
                                            color: Color.fromRGBO(
                                                168, 168, 168, 1)),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    // color:Colors.red,
                                    child: Icon(Icons.chevron_right),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            // print(result);
                            FocusScope.of(context).requestFocus(FocusNode());
                            // type 1
                            result = await CityPickers.showCityPicker(
                              context: context,
                              height: 240,
                              locationCode: _areaId == '' ? '110000' : _areaId,
                            );
                            if (result != null) {
                              _area = result.provinceName +
                                  '-' +
                                  result.provinceName +
                                  '-' +
                                  result.cityName +
                                  '-' +
                                  result.areaName +
                                  ',' +
                                  result.areaId;
                              _areaId = result.areaId;
                              _vareaController.text = result.provinceName +
                                  '-' +
                                  result.provinceName +
                                  '-' +
                                  result.cityName +
                                  '-' +
                                  result.areaName;
                            }
                          },
                        ),

                        // 详细地址
                        Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),
                              0, ScreenUtil().setWidth(20), 0),
                          // padding:EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                          // alignment: Alignment.centerLeft,
                          decoration: new UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Color.fromRGBO(249, 249, 249, 1),
                            ),
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("详细地址",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12))),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: TextField(
                                    controller: _vaddrController,
                                    cursorColor: Colors.black,
                                    maxLength: 100,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '例：滨海街道 胜利小区 5号楼203室',
                                        hintStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(12),
                                            color: Color.fromRGBO(
                                                168, 168, 168, 1))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      this._isDefault = !this._isDefault;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        left: ScreenUtil().setWidth(35),
                        right: ScreenUtil().setWidth(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(_isDefault
                            ? Icons.check_circle
                            : Icons.check_circle_outline),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("设为默认地址",
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(12))),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(30),
                      left: ScreenUtil().setWidth(15),
                      right: ScreenUtil().setWidth(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Color(0xFF414141),
                          child: Text(
                            "保存",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          onPressed: _savePressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ))),
    );
  }

  // 所选地区
  _savePressed() async {
    //验证码验证
    if (_vnameController.text == "") {
      Fluttertoast.showToast(msg: "请输入收件人姓名");
      return;
    }
    //手机号验证
    if (!StringUtils.isChinaPhoneLegal(_vtelController.text)) {
      Fluttertoast.showToast(msg: "请输入正确的手机号");
      return;
    }
    //手机号验证
    if (_area == "") {
      Fluttertoast.showToast(msg: "选择所在的地区");
      return;
    }
    //手机号验证
    if (_vaddrController.text == "") {
      Fluttertoast.showToast(msg: "请输入详细地址");
      return;
    }

    //发送 保存 请求
    var res = await Api.getInstance().addAddress(_vnameController.text,
        _vtelController.text, _area, _vaddrController.text, _isDefault);
    print(res);
    var code = res["code"] as String;
    var data = res["data"] as String;
    if (code == "200") {
      Fluttertoast.showToast(msg: "保存成功");
      //返回 不同订单页面
      Navigator.pop(context, {
        'id': data,
        'name': _vnameController.text,
        'tel': _vtelController.text,
        'area': _area,
        'address': _vaddrController.text,
      });
    } else {
      Fluttertoast.showToast(msg: '保存失败');
    }
  }
}
