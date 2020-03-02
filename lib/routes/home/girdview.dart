import 'package:Bidder/routes/search/searchresult.dart';

import '../../common/bidder_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//六个分类
class GirdViewHome extends StatefulWidget {
  @override
  _GirdViewHomeState createState() => _GirdViewHomeState();
}

class _GirdViewHomeState extends State<GirdViewHome> {
  List<dynamic> typeslist = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  void _loadTypes() async {
    // 发送 登录 请求
    var res = await Api.getInstance().goodsType();
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          typeslist = data;
        });
      }
    }
  }

  List<GestureDetector> _buildGridView() {
    List<GestureDetector> views = new List<GestureDetector>();
    for (dynamic type in typeslist) {
      var _g = new GestureDetector(
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(65),
              height: ScreenUtil().setHeight(65),
              child: CachedNetworkImage(
                imageUrl: type["image"],
                placeholder: (context, url) => Image.asset("images/app.png"),
                errorWidget: (context, url, error) =>
                    Image.asset("images/app.png"),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(4)),
              child: Text(type["name"],
                  style: TextStyle(fontSize: ScreenUtil().setSp(12))),
            )
          ],
        )),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); // 缩回键盘
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchResult(searchText: type["name"] == "全部分类"? '' : type["name"] )));
        },
      );
      views.add(_g);
    }
    return views;
  }

  @override
  Widget build(BuildContext context) {
    print('build _GirdViewHomeState');
    return typeslist.length > 0
        ? GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            primary: true,
            padding: EdgeInsets.only(
                // left: ScreenUtil().setWidth(05),
                top: ScreenUtil().setHeight(18),
                // bottom: ScreenUtil().setHeight(20)
                ),
            crossAxisCount: 3, //横轴3个widget
            crossAxisSpacing: 0, //水平widget间距
            mainAxisSpacing: 0, //垂直widget间距
            childAspectRatio: 2 / 1.6,
            children: _buildGridView(),
          )
        : Row();
  }
}
