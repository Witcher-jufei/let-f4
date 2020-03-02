import 'package:Bidder/common/bidder_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  // 消息数据源
  List<dynamic> msglist = new List<dynamic>();
  // 加载 页数
  int page = 0;
  // 发送 选购列表  请求
  void _loadMsgs() async {
    print(page);
    var res = await Api.getInstance().getMsgsByUid({"page": page});
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          // gooslist = data;
          msglist.addAll(data);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMsgs();
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
            "新闻",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      body: SafeArea(
        top: true,
        child: Column(
          children: <Widget>[
            // 标题
            // HeadView(title: '消息', backShow: true, msgShow: false),
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
                          return MsgItem(item: msglist[index]);
                        }, childCount: msglist.length),
                      ),
                    ),
                  ],
                  onRefresh: () async {
                    page = 1;
                    msglist.clear();
                    _loadMsgs();
                  },
                  onLoad: () async {
                    page++;
                    _loadMsgs();
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
