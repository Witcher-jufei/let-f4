import 'package:Bidder/common/bidder_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home/gooditem.dart';
import 'information/Information.dart';

class Collection extends StatefulWidget {
  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  EasyRefreshController _controller = EasyRefreshController();
  // 数据源
  List<dynamic> _list = new List<dynamic>();
  // 加载 页数
  int page = 0;

  // 发送 收藏列表  请求
  void _loadData() async {
    var res = await Api.getInstance().collectionGoods(page);
    var code = res["code"] as String;
    if (code == '10001' || code == '10002') {
      Fluttertoast.showToast(msg: '登录信息失效');
    }
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      setState(() {
        _list.addAll(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          // leading: BackButton(color: Colors.black),
          leading:Container(),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "收藏",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Information()));
              },
              child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                width: 18,
                height: 18,
                child: Image.asset("images/msg.png"),
              ),
            ),
          ],
        ),

      body: SafeArea(
        top: true,
        child: Column(
          children: <Widget>[
            // HeadView(title: '收藏'),
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
                  controller: _controller,
                    emptyWidget: _list.length == 0
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: ScreenUtil().setWidth(15),
                            // mainAxisSpacing: ScreenUtil().setHeight(22),
                            childAspectRatio: 0.7),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return GoodItem(item: _list[index]);
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
        ),
      ),
    );
  }
}

class MsgItem extends StatelessWidget {
  final dynamic item;
  const MsgItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        child: Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(15),
            left: ScreenUtil().setWidth(15),
            right: ScreenUtil().setWidth(15),
          ),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item["title"],
                  style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item["created_at"],
                    style: TextStyle(
                        color: Color.fromRGBO(211, 211, 211, 1),
                        fontSize: ScreenUtil().setSp(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(5),
            left: ScreenUtil().setWidth(15),
            right: ScreenUtil().setWidth(15),
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(211, 211, 211, 1), width: 1))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(20),
                  ),
                  alignment: Alignment.centerRight,
                  child: Text(
                    item["des"],
                    style: TextStyle(
                        color: Color.fromRGBO(65, 65, 65, 1),
                        fontSize: ScreenUtil().setSp(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
