import 'dart:ui';
import '../../common/bidder_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'gooditem.dart';
import 'swiperview.dart';
import 'girdview.dart';
import 'special.dart';

class SelectBuy extends StatefulWidget {
  final List<dynamic> piclist;
  const SelectBuy({Key key, this.piclist}) : super(key: key);

  @override
  _SelectBuyState createState() => _SelectBuyState();
}

class _SelectBuyState extends State<SelectBuy> {
  // 选购商品数据源
  List<dynamic> gooslist = new List<dynamic>();
  // 加载 页数
  int page = 0;

  // 发送 选购列表  请求
  void _loadChooseGoods() async {
    var res = await Api.getInstance().chooseGoodsList(page);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          // gooslist = data;
          gooslist.addAll(data);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_SelectBuyState ...');
    return Expanded(
      child: Stack(children: <Widget>[
        Container(
          height: double.infinity,
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
            SliverList(
              delegate: SliverChildListDelegate([
                new Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      width: double.infinity,
                      height: ScreenUtil().setHeight(220),
                      child: SwiperView(), //轮播图
                    ),
                    Container(
                      // color: Colors.red,
                      width: double.infinity,
                      height: ScreenUtil().setHeight(240),
                      child: GirdViewHome(), //九宫格视图
                    ),
                    Container(
                      // color: Colors.blue,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(15),
                          ScreenUtil().setWidth(22),
                          ScreenUtil().setWidth(15),
                          0),
                      height: ScreenUtil().setHeight(123),
                      child: SpecialView(), // 专题
                    ),
                    Container(
                      width: double.infinity,
                      // color: Colors.red,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(15),
                          ScreenUtil().setHeight(35),
                          0,
                          0
                          ),
                      child: Text(
                        "为您推荐",
                        style: TextStyle(
                          color: Color.fromRGBO(65, 65, 65, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(14),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            ),
            SliverPadding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: ScreenUtil().setWidth(15),
                  // mainAxisSpacing: ScreenUtil().setHeight(22),
                  childAspectRatio: 0.7
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return GoodItem(item:gooslist[index]);
                }, childCount: gooslist.length),
              ),
            ),
          ],
          onRefresh: () async {
            page = 1;
            gooslist.clear();
            _loadChooseGoods();
          },
          onLoad: () async {
            page++;
            _loadChooseGoods();
          },
        )
      ]),
    );
  }
}
