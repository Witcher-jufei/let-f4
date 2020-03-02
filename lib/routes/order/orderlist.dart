import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/details/orderview.dart';
import 'package:Bidder/routes/order/confirmorder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseOrderList extends StatefulWidget {
  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<ChooseOrderList>
    with SingleTickerProviderStateMixin {
  _ChooseState();

  List tabs = ["待支付", "待发货",  "待收货", "已完成", "全部"];

  //用于控制/监听Tab菜单切换
  //TabBar和TabBarView正是通过同一个controller来实现菜单切换和滑动状态同步的。
  TabController tabController;

    // 数据源
  List<List<dynamic>> _dataslist = [new List<dynamic>(), new List<dynamic>(), new List<dynamic>(), new List<dynamic>(), new List<dynamic>()];
  // 加载 页数
  List _pages = [0 ,0 ,0 ,0, 0];


  // 发送 列表  请求
  void _loadData(int _status) async {
    var res = await Api.getInstance().chooseOrderList(_pages[_status], _status);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      setState(() {
        _dataslist[_status].addAll(data);
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
      _pages[2] = 1;
      _dataslist[2].clear();
      _loadData(2);

    }
  }

  @override
  void initState() {
    ///初始化，这个函数在生命周期中只调用一次
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    _loadData(0);
    _loadData(1);
    _loadData(2);
    _loadData(3);
    _loadData(4);
  }

  @override
  void didChangeDependencies() {
    ///在initState之后调 Called when a dependency of this [State] object changes.
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        elevation: 0, //取消阴影
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        title: Container(
          child: Text(
            "选购订单",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        bottom: buildTabBar(), //底部选项卡
      ),
      // body:  buildBodyView(),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          // 订单状态 0待支付1 已支付待发货 2已发货待收货3完成 4 
          // new ChooseOrderListTab(status: 0),
          // new ChooseOrderListTab(status: 1),
          // new ChooseOrderListTab(status: 2),
          // new ChooseOrderListTab(status: 3),
          // new ChooseOrderListTab(status: 4),// 4 为全部
          buildStatus(0),
          buildStatus(1),
          buildStatus(2),
          buildStatus(3),
          buildStatus(4),
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  buildTabBar() {
    //构造 TabBar
    Widget tabBar = TabBar(
        //设置为false tab 将平分宽度，为true tab 将会自适应宽度
        isScrollable: true,
        //设置tab文字得类型
        labelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w300),
        //设置tab选中得颜色
        labelColor: Color.fromRGBO(65, 65, 65, 1),
        //设置tab未选中得颜色
        unselectedLabelColor: Color.fromRGBO(65, 65, 65, 1),
        //设置指示器的颜色
        indicatorColor: Color(0xFF1A2BFF),
        indicatorWeight: 4,
        indicatorPadding: EdgeInsets.all(7),
        indicatorSize: TabBarIndicatorSize.tab,
        //生成Tab菜单
        controller: tabController,
        //构造Tab集合
        tabs: tabs.map((e) => Tab(text: e)).toList());

    return tabBar;
  }

  //
  Column buildStatus(int _status) {
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
                      return NewItem(item: _dataslist[_status][index], pcontext: context,);
                    }, childCount: _dataslist[_status].length),
                  ),
                ),
              ],
              onRefresh: () async {
                _pages[_status] = 1;
                _dataslist[_status].clear();
                _loadData(_status);
              },
              onLoad: () async {
                _pages[_status]++;
                _loadData(_status);
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
  final BuildContext pcontext;
  const NewItem({Key key, this.item, this.pcontext}) : super(key: key);

  //不同 状态 显示 不同的 组件
  Widget _showStatusWidget(context) {
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
                onPressed: () async {
                  var _info = {'orderId':item['order_id'], 'addr_id':item['addr_id'], 'gid':item['goodsid'], 'price':item['price'],'remarks': item['remarks']};
                  var _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmOrder(info: _info)));
                  if (_result != null) {
                    // Navigator.of(context).pop(_result);
                    //
                    _ChooseState _s = pcontext.findAncestorStateOfType<_ChooseState>();
                    _s._pages[0] = 1;
                    _s._dataslist[0].clear();
                    _s._loadData(0);
                  }


                }));
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
                onPressed: () {
                  var _info = {'orderId':item['order_id'], 'addr_id':item['addr_id'], 'gid':item['goodsid'], 'price':item['price'],'remarks': item['remarks']};
                  _ChooseState _s = pcontext.findAncestorStateOfType<_ChooseState>();
                  _s._confirmOrder(item['order_id']);

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
    return Container(
        // padding: EdgeInsets.only(
        //     left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        // color: Colors.green,
        child: Column(
      children: <Widget>[

        GestureDetector(
          onTap: () async {
           var _result = await  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orderId: item['order_id'])));
           if (_result != null) {
             _ChooseState _s = pcontext.findAncestorStateOfType<_ChooseState>();
              _s._pages[int.parse(item['order_status'])] = 1;
              _s._dataslist[int.parse(item['order_status'])].clear();
              _s._loadData(int.parse(item['order_status']));
           }
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
                                  fontSize: 14),
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
                                    child: _showStatusWidget(context),
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
