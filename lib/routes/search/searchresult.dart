import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/home/gooditem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SearchResult extends StatefulWidget {
  final String searchText;
  SearchResult({Key key, this.searchText}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool btnEnable1 = true; // 排序
  bool btnEnable2 = false;
  bool btnEnable3 = false;
  bool btnEnable4 = false;
  bool btnEnable5 = false;
  bool btnEnable6 = false;

  List<String> types = new List<String>();

  final _vminController = TextEditingController();
  final _vmaxController = TextEditingController();

  Map<String, dynamic> _searchInfo = {};

  @override
  void initState() {
    super.initState();
    _searchTC.text = widget.searchText;

    if (widget.searchText == '潮流玩具') btnEnable2 = true;
    if (widget.searchText == '限量雕塑') btnEnable3 = true;
    if (widget.searchText == '限量版画') btnEnable4 = true;
    if (widget.searchText == '时尚衍生') btnEnable5 = true;
    if (widget.searchText == '艺术原作') btnEnable6 = true;

    _loadSearchGoods();
  }

  EasyRefreshController _controller = EasyRefreshController();
  var _searchTC = new TextEditingController();
  // 选购商品数据源
  List<dynamic> gooslist = new List<dynamic>();
  // 加载 页数
  int page = 1;
  // 发送 选购列表  请求
  void _loadSearchGoods() async {
    _searchInfo['search'] = _searchTC.text;
    _searchInfo['page'] = page;
    
    var res = await Api.getInstance().chooseGoodsSearch(_searchInfo);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      gooslist.addAll(data);
    }
    setState(() {});
  }

  // 充值筛选
  _reset() {
    setState(() {
      btnEnable1 = true; // 排序
      // 品类
      btnEnable2 = false;
      btnEnable3 = false;
      btnEnable4 = false;
      btnEnable5 = false;
      btnEnable6 = false;
      //tpyes
      types.clear();
      // 价格
      _vminController.text = '';
      _vmaxController.text = '';
    });
  }

  _goSeach() {
    // 排序
    if (btnEnable1)
      _searchInfo['orderby'] = 1.toString();
    else
      _searchInfo['orderby'] = 2.toString();
    types.clear();
    //潮流玩具
    if (btnEnable2)
      types.add('2');
    else
      types.remove('2');
    //types
    if (btnEnable3)
      types.add('3');
    else
      types.remove('3');
    //限量版画
    if (btnEnable4)
      types.add('4');
    else
      types.remove('4');
    //时尚衍生
    if (btnEnable5)
      types.add('5');
    else
      types.remove('5');
    //艺术原作
    if (btnEnable6)
      types.add('6');
    else
      types.remove('6');

    var _types = '';
    types.forEach((_type) {
      _types = _types + _type + ',';
    });
    if(_types.length > 0) 
      _searchInfo['type'] = _types.substring(0, _types.length - 1);
    else
      _searchInfo.remove('type');

    if (_vminController.text != '')
      _searchInfo['price_min'] = _vminController.text;
    else
      _searchInfo.remove('price_min');
    if (_vmaxController.text != '')
      _searchInfo['price_max'] = _vmaxController.text;
    else
      _searchInfo.remove('price_max');
    
    page = 1;
    gooslist.clear();
    _controller.callRefresh();
    Navigator.pop(context);
  }

  // 确定 搜索
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: Column(
            children: <Widget>[
              //搜索框
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15),
                    right: ScreenUtil().setWidth(15)),
                color: Color.fromRGBO(249, 249, 249, 1),
                // color: Colors.red,

                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //返回按钮
                    Expanded(
                      flex: 1,
                      child: Container(
                        // padding: EdgeInsets.only(top: ScreenUtil().setHeight(38)),
                        // color: Colors.green,
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 25.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        // color: Colors.blue,
                        // padding: EdgeInsets.only(top: ScreenUtil().setHeight(38)),
                        alignment: Alignment.topCenter,

                        child: TextField(
                            controller: _searchTC,
                            enableInteractiveSelection: false,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              // isDense: true,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromRGBO(168, 168, 168, 1),
                                width: 1,
                              )),
                              prefixIcon: Container(
                                padding: EdgeInsets.only(left: 0, top: 5),
                                child: Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(168, 168, 168, 1),
                                  size: ScreenUtil().setHeight(25),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 16),
                              // contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            ),
                            onSubmitted: (text) async {
                              page = 1;
                              gooslist.clear();
                              _reset();
                              // _loadSearchGoods({'searchtext': text});
                              _controller.callRefresh();
                            }),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Container(
                          // padding: EdgeInsets.only(top: ScreenUtil().setHeight(38)),
                          // color: Colors.green,
                          alignment: Alignment.centerRight,
                          child: Builder(builder: (context){
                            return GestureDetector(
                              onTap: () {
                                print("msg num tap");
                                Scaffold.of(context).openEndDrawer();
                              },
                              child: Image.asset(
                                "images/select.png",
                                width: ScreenUtil().setWidth(21),
                                height: ScreenUtil().setHeight(22),
                              ),
                            );
                          }),
                      ),
                    ),
                  ],
                ),
              ),

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
                    controller: _controller,
                    emptyWidget: gooslist.length == 0
                        ? Container(
                            // color: Colors.red,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 80.0,
                                  height: 80.0,
                                  child: Image.asset('images/nodata.png'),
                                ),
                                Text(
                                  '没有更多数据',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.grey[400]),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 3,
                                ),
                              ],
                            ),
                          )
                        : null,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: ScreenUtil().setWidth(15),
                                  // mainAxisSpacing: ScreenUtil().setHeight(22),
                                  childAspectRatio: 0.7),
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return GoodItem(item: gooslist[index]);
                          }, childCount: gooslist.length),
                        ),
                      ),
                    ],
                    onRefresh: () async {
                      page = 1;
                      gooslist.clear();
                      _loadSearchGoods();
                    },
                    onLoad: () async {
                      page++;
                      _loadSearchGoods();
                    },
                  )
                ]),
              )
            ],
          ),
        ),
        endDrawer: _buildDrawer(),
      ),
    );
  }

  // 右侧 抽屉栏
  Drawer _buildDrawer() {
    return Drawer(
      child: ConstrainedBox(
          constraints: BoxConstraints.expand(width: 2.0),
          child: Scaffold(
            body: SafeArea(
              top: true,
              child: Container(
                color: Colors.white,
                // width: ScreenUtil().setWidth(200),
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      width: double.infinity,
                      decoration: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Color(0xFFD3D3D3),
                        ),
                      ),
                      child: Text(
                        "排序",
                        style: TextStyle(
                            color: Color.fromRGBO(65, 65, 65, 1),
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable1 = !btnEnable1;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable1
                            ? Color.fromRGBO(211, 211, 211, 1)
                            : Color(0xFFE6E6E6),
                        // color: Color(0xFFE6E6E6),
                        // color: Colors.red,
                        // decoration: BoxDecoration(
                        //   border:
                        //       Border.all(color: Color.fromRGBO(211, 211, 211, 1), width: 1)),
                        child: Center(
                          child: Text(
                            "价格升序",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable1 = !btnEnable1;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable1
                            ? Color(0xFFE6E6E6)
                            : Color.fromRGBO(211, 211, 211, 1),
                        child: Center(
                          child: Text(
                            "价格降序",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      width: double.infinity,
                      decoration: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Color(0xFFD3D3D3),
                        ),
                      ),
                      child: Text(
                        "品类",
                        style: TextStyle(
                            color: Color.fromRGBO(65, 65, 65, 1),
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable2 = !btnEnable2;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable2
                            ? Color.fromRGBO(211, 211, 211, 1)
                            : Color(0xFFE6E6E6),
                        child: Center(
                          child: Text(
                            "潮流玩具",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable3 = !btnEnable3;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable3
                            ? Color.fromRGBO(211, 211, 211, 1)
                            : Color(0xFFE6E6E6),
                        child: Center(
                          child: Text(
                            "限量雕塑",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable4 = !btnEnable4;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable4
                            ? Color.fromRGBO(211, 211, 211, 1)
                            : Color(0xFFE6E6E6),
                        child: Center(
                          child: Text(
                            "限量版画",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable5 = !btnEnable5;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable5
                            ? Color.fromRGBO(211, 211, 211, 1)
                            : Color(0xFFE6E6E6),
                        child: Center(
                          child: Text(
                            "时尚衍生",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          btnEnable6 = !btnEnable6;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(28),
                        color: btnEnable6
                            ? Color.fromRGBO(211, 211, 211, 1)
                            : Color(0xFFE6E6E6),
                        child: Center(
                          child: Text(
                            "艺术原作",
                            style: TextStyle(
                                color: Color.fromRGBO(65, 65, 65, 1),
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      width: double.infinity,
                      decoration: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Color(0xFFD3D3D3),
                        ),
                      ),
                      child: Text(
                        "价格区间",
                        style: TextStyle(
                            color: Color.fromRGBO(65, 65, 65, 1),
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      // margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: new TextField(
                              controller: _vminController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Color.fromRGBO(65, 65, 65, 1),
                                  fontSize: ScreenUtil().setSp(12),
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                // isDense: true,
                                hintText: '最低价',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromRGBO(168, 168, 168, 1),
                                  width: 1,
                                )),
                                // contentPadding: EdgeInsets.all(1.0)
                                contentPadding:
                                    EdgeInsets.only(top: 10, left: 10),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // color: Colors.red,
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: Text(
                                "——",
                                style: TextStyle(
                                    color: Color.fromRGBO(65, 65, 65, 1),
                                    fontSize: ScreenUtil().setSp(12),
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new TextField(
                              controller: _vmaxController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Color.fromRGBO(65, 65, 65, 1),
                                  fontSize: ScreenUtil().setSp(12),
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                // isDense: true,
                                hintText: '最高价',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromRGBO(168, 168, 168, 1),
                                  width: 1,
                                )),
                                contentPadding:
                                    EdgeInsets.only(top: 10, left: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      color: Color.fromRGBO(249, 249, 249, 1),
                      width: ScreenUtil().setWidth(140),
                      height: ScreenUtil().setHeight(41),
                      child: Center(
                        child: Text("重置",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.black)),
                      ),
                    ),
                    onTap: () {
                      _reset();
                    },
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Container(
                      height: ScreenUtil().setHeight(41),
                      color: Color.fromRGBO(65, 65, 65, 1),
                      child: Center(
                        child: Text("确定",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.white)),
                      ),
                      // color: Colors.blue
                    ),
                    onTap: () {
                      _goSeach();
                    },
                  ))
                ],
              ),
            ),
          )),
    );
  }
   Widget createAlertDialog(){
    return new AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      title: new Text('我是标题'),
      content: new Text('我是内容'),
      actions: <Widget>[
        new FlatButton(
          child: new Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();//关闭对话框
          },
        ),

        new FlatButton(
          child: new Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

