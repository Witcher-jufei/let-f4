import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/order/suborder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'orderview.dart';

class GoodView extends StatefulWidget {
  final String gid;
  const GoodView({Key key, this.gid}) : super(key: key);
  @override
  _GoodViewState createState() => _GoodViewState();
}

class _GoodViewState extends State<GoodView> {
  // 请求数据
  dynamic _info;
  void _loadGoodInfo() async {
    // 发送 登录 请求
    var res = await Api.getInstance().chooseGoodsDetails(widget.gid);
    // print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          _info = data[0];
        });
      }
    }
  }

  void _addCollection() async {
    // 发送 收藏 请求
    var res = await Api.getInstance().addGoodsCollection(_info["id"]);
    var code = res["code"] as String;
    if (code == "200") {
      setState(() {
        _info["collection"] = '1';
      });
    } else {
      setState(() {
        _info["collection"] = '0';
      });
    }
    Fluttertoast.showToast(msg: res["msg"]);
  }

  @override
  void initState() {
    super.initState();
    _loadGoodInfo();
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
            "选购",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
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
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(17)),
                width: 17,
                height: 16,
                child: Image.asset("images/kefu.png"),
              ),
            ),
            
            // GestureDetector(
            //   onTap: () {
            //     // showModalBottomSheet(
            //     //       context: context,
            //     //       builder: (BuildContext context) {
            //     //         return _shareWidget(context);
            //     //       });
            //   },
            //   child: Container(
            //   margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
            //   width: 15,
            //   height: 15,
            //   child: Image.asset("images/share.png"),
            // )
            // ),
            
          ],
        ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: _info == null
            ? Container(
                color: Colors.white,
              )
            : Column(
                children: <Widget>[
                  // 内容
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        // 轮播图
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15)),
                          width: ScreenUtil().setWidth(375),
                          height: ScreenUtil().setHeight(375),
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return CachedNetworkImage(
                                imageUrl: _info["image"][index],
                                placeholder: (context, url) =>
                                    Image.asset("images/app.png"),
                                errorWidget: (context, url, error) =>
                                    Image.asset("images/app.png"),
                              );
                            },
                            onTap: (int index) {
                              // Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 SearchResult(searchText: strs[1])));
                            },
                            itemCount: _info["image"].length,
                            scrollDirection: Axis.horizontal,
                            loop: true,
                            duration: 300,
                            autoplay: true,
                            // pagination: SwiperPagination(),//原点
                          ),
                        ),

                        // 商品名称
                        Container(
                          width: double.infinity,
                          // height: ScreenUtil().setHeight(89),
                          color: Color.fromRGBO(249, 249, 249, 1),
                          // color: Colors.red,
                          alignment: Alignment.center,
                          child: Container(
                            // color: Colors.teal,
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                right: ScreenUtil().setWidth(15)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(19)),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "${_info["name"]}",
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(6),
                                    bottom: ScreenUtil().setHeight(10),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${_info["present_price"]}",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(8)),
                                          child: Text(
                                            "${_info["original_price"]}",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.w200,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          )),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                        ),
                                      ),
                                      // 预售
                                      Container(
                                        // color: Colors.green,
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(15)),
                                        child: _info["goods_type"] == '2'
                                            ? Image.asset(
                                                "images/yushou.png",
                                                width:
                                                    ScreenUtil().setWidth(29),
                                                height:
                                                    ScreenUtil().setWidth(16),
                                              )
                                            : null,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        //logo
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(17),
                            left: ScreenUtil().setWidth(15),
                            right: ScreenUtil().setWidth(15),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                // color: Colors.teal,
                                // padding: EdgeInsets.only(
                                //     top: ScreenUtil().setHeight(17)),
                                decoration: new UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                  ),
                                  // insets: EdgeInsets.fromLTRB(0, 0, 0, 10)
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CachedNetworkImage(
                                        height: ScreenUtil().setHeight(40),
                                        width: ScreenUtil().setWidth(40),
                                        imageUrl: _info["brand_image"],
                                        fit: BoxFit.fitHeight,
                                        placeholder: (context, url) =>
                                            Image.asset("images/app40px.png"),
                                        errorWidget: (context, url, error) =>
                                            Image.asset("images/app40px.png"),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(11)),
                                      child: Text("${_info["brand_name"]}"),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(6),
                                ),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                height: ScreenUtil().setHeight(40),
                                decoration: new UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                  ),
                                ),
                                child: Text("系列：${_info["series"]}"),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(6),
                                ),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                height: ScreenUtil().setHeight(40),
                                decoration: new UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                  ),
                                ),
                                child: Text("年份：${_info["year"]}"),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(6),
                                ),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                height: ScreenUtil().setHeight(40),
                                decoration: new UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                  ),
                                ),
                                child: Text("材质：${_info["material"]}"),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(6),
                                ),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                height: ScreenUtil().setHeight(40),
                                decoration: new UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                  ),
                                ),
                                child: Text("发出地：${_info["address"]}"),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(6),
                                ),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                height: ScreenUtil().setHeight(40),
                                decoration: new UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                  ),
                                ),
                                child: Text("尺寸：${_info["size"]}"),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                ),
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(10),
                                ),
                                width: double.infinity,
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
                                      child: Text("发货时间：${_info["times"]}"),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                ),
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(10),
                                ),
                                width: double.infinity,
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
                                      child: Text(
                                        "说明：${_info["explain"]}",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(168, 168, 168, 1),
                                          fontSize: ScreenUtil().setSp(12),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //占位
                              Container(
                                // color: Colors.teal,
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(6),
                                ),
                                width: double.infinity,
                                height: ScreenUtil().setHeight(80),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      child: Container(
        color: Colors.blue,
        height: ScreenUtil().setHeight(60),
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Color(0xFFF9F9F9),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    // color: Color(0xFF414141),
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              // color: Colors.red,
                              child: Image.asset(
                                _info == null || _info["collection"] == '0'
                                    ? "images/collection/collection.png"
                                    : "images/collection/collection-s.png",
                                width: ScreenUtil().setWidth(15),
                                height: ScreenUtil().setHeight(14),
                              ),
                            ),
                            Container(
                              color: Colors.lightBlue,
                              width: ScreenUtil().setWidth(5),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              // color: Colors.green,
                              child: Text("收藏",
                                  style: TextStyle(
                                      color: Color(0xFF414141),
                                      fontSize: ScreenUtil().setSp(12))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _addCollection();
                  },
                ),
                flex: 2,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: Color(0xFF414141),
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              // color: Colors.red,
                              child: Image.asset(
                                "images/goumai.png",
                                width: ScreenUtil().setWidth(15),
                                height: ScreenUtil().setHeight(14),
                              ),
                            ),
                            Container(
                              color: Colors.lightBlue,
                              width: ScreenUtil().setWidth(5),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              // color: Colors.green,
                              child: Text("购买",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: ScreenUtil().setSp(12))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    var _result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SubOrder(info: _info,)));
                    if (_result != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orderId: _result)));
                    }
                        
                  },
                ),
                flex: 3,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _shareWidget(BuildContext context) {
    List<String> nameItems = ['微信','朋友圈','微博','QQ'];
    List<String> urlItems = ['app.png','app.png','app.png','app.png'];
    
    return new Container(
      height: 180.0,
      margin:  EdgeInsets.only(left: 20, right: 20),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                GestureDetector(
                  onTap: () {

                  },
                  child: Expanded(
                    flex: 1,
                    child: new Image.asset( 'images/sharewx.png', width: 60, height: 60),
                  ),
                ),
                
                Expanded(
                  flex: 1,
                  child: new Image.asset( 'images/sharedc.png', width: 60, height: 60),
                ),
                Expanded(
                  flex: 1,
                  child: new Image.asset( 'images/sharewb.png', width: 60, height: 60),
                ),
                Expanded(
                  flex: 1,
                  child: new Image.asset( 'images/shareqq.png', width: 60, height: 60),
                ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.only(top: 20),
            child: MaterialButton(
              color: Colors.white10,
              child: Text('取消'), onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

}
