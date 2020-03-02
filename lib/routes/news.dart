import 'package:Bidder/common/bidder_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'information/Information.dart';

class NewsRoute extends StatefulWidget {
  @override
  _NewsRouteState createState() => _NewsRouteState();
}

class _NewsRouteState extends State<NewsRoute> {
  EasyRefreshController _controller = EasyRefreshController();
  // 数据源
  List<dynamic> _list = new List<dynamic>();
  // 加载 页数
  int page = 0;
  // 发送 收藏列表  请求
  void _loadData() async {
    var res = await Api.getInstance().getNews(page);
    print(res);
    var code = res["code"] as String;
    if (code == '10001' || code == '10002') {
      Fluttertoast.showToast(msg: '登录信息失效');
    }
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
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          // leading: BackButton(color: Colors.black),
          leading:Container(),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "新闻",
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
        ),
      ),
    );
  }
}

class NewItem extends StatelessWidget {
  final dynamic item;
  const NewItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(item["url"])) {
          await launch(item["url"]);
        } else {
          throw 'Could not launch $item["url"]';
        }
      },
      child: Container(
        // padding: EdgeInsets.only(
        //     left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        // color: Colors.green,
        child: Column(
          children: <Widget>[
            Container(
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
                                  item['title'],
                                  style: TextStyle(
                                      color: Color.fromRGBO(61, 61, 61, 1),
                                      fontSize: ScreenUtil().setSp(11),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil().setHeight(16)),
                                // color: Colors.red,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Image.asset(
                                        "images/date.png",
                                        width: ScreenUtil().setWidth(15),
                                        height: ScreenUtil().setHeight(15),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setHeight(10)),
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        item["created_at"],
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(10),
                                            fontWeight: FontWeight.w300),
                                      ),
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
            Container(
              color: Colors.white,
              height: ScreenUtil().setHeight(16),
            ),
            Container(
              color: Color.fromRGBO(211, 211, 211, 1),
              height: ScreenUtil().setHeight(1),
            ),
            
          ],
        )),
    );
    
    
  }
}
