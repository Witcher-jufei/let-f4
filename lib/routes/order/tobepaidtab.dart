import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/details/orderview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseOrderListTab extends StatefulWidget {
  int status; // 订单状态
  ChooseOrderListTab({Key key, this.status}) : super(key: key);
  @override
  _ChooseOrderListTabTabState createState() =>
      _ChooseOrderListTabTabState();
}

class _ChooseOrderListTabTabState
    extends State<ChooseOrderListTab> {
  // 数据源
  List<dynamic> _list = new List<dynamic>();
  // 加载 页数
  int page = 0;
  // 发送 列表  请求
  void _loadData() async {
    var res = await Api.getInstance().chooseOrderList(page, widget.status);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          _list.addAll(data);
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
    return Column(
      children: <Widget>[
        // HeadView(title: '新闻'),
        Expanded(
          child: Stack(children: <Widget>[
            Container(
              // color: Colors.green,
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
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(15),
                    left: ScreenUtil().setWidth(15),
                    right: ScreenUtil().setWidth(15),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return NewItem(item: _list[index]);
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
                page++;
                _loadData();
              },
            )
          ]),
        )
      ],
    );
  }
}

class NewItem extends StatelessWidget {
  final dynamic item;
  const NewItem({Key key, this.item}) : super(key: key);

  //不同 状态 显示 不同的 组件
  Widget _showStatusWidget() {
    Widget _w;
    switch(item['order_status']) {
      case '0':
        _w = new Container(
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setHeight(30),
            child: FlatButton(
                textColor: Colors.white, //文本颜色
                color: Color(0xFF414141),
                child: Text('支付', style: TextStyle(fontSize: 12),),
                onPressed: () {}));
      break;
      case '1':
        _w = new Text('待发货', style: TextStyle(fontSize: 12, color: Color(0xFF414141)));
      break;
      case '2':
        _w = new Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(30),
            child: FlatButton(
                textColor: Colors.white, //文本颜色
                color: Color(0xFF414141),
                child: Text('确认收货', style: TextStyle(fontSize: 12),),
                onPressed: () {}));
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
    return Container(
        // padding: EdgeInsets.only(
        //     left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        // color: Colors.green,
        child: Column(
      children: <Widget>[

        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orderId: item['order_id'])));
          },
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
            color: Colors.white,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      // color: Colors.indigoAccent,
                      child: CachedNetworkImage(
                        imageUrl: item["image"],
                        width: ScreenUtil().setWidth(118),
                        height: ScreenUtil().setHeight(118),
                        placeholder: (context, url) =>
                            Image.asset("images/app.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset("images/app.png"),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setHeight(16)),
                            alignment: Alignment.topLeft,
                            // color: Colors.red,
                            child: Text(
                              item['goodsname'],
                              style: TextStyle(
                                  color: Color.fromRGBO(61, 61, 61, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                                left: ScreenUtil().setHeight(16)),
                            alignment: Alignment.topLeft,
                            // color: Color.fromRGBO(
                            //     211, 243, 255, 1),
                            child: Text(item['business'],
                              style: TextStyle(
                                backgroundColor: Color.fromRGBO(211, 243, 255, 1),
                                color: Color.fromRGBO(18, 175, 234, 1),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setHeight(16)),
                            // color: Colors.red,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('实付 ' + item["price"],
                                      style: TextStyle(fontSize: 12)
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: _showStatusWidget(),
                                  )
                                ),

                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                ],
              ),
            )),
        ),

        Container(
          color: Colors.white,
          height: ScreenUtil().setHeight(16),
        ),
        Container(
          color: Color.fromRGBO(211, 211, 211, 1),
          height: ScreenUtil().setHeight(1),
        ),
        // Container(
        //   color: Colors.white,
        //   height: ScreenUtil().setHeight(14),
        // ),
      ],
    ));
  }



}
