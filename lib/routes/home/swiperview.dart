import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/details/goodview.dart';
import 'package:Bidder/routes/search/searchresult.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//轮播图
class SwiperView extends StatefulWidget {
  @override
  _SwiperViewState createState() => _SwiperViewState();
}

class _SwiperViewState extends State<SwiperView> {
  // 轮播图
  List<dynamic> _piclist = new List<dynamic>();

  _loadBanner() async {
    // 发送 登录 请求
    var res = await Api.getInstance().rotaryMap();
    // print(res);
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          _piclist = data;
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
     _loadBanner();
  }
  @override
  Widget build(BuildContext context) {
    print('_loadBanner');
    return Row(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
            child: Column(
              children: <Widget>[
                Container(
                    child: Flexible(
                  child: Container(
                    width: ScreenUtil().setWidth(345),
                    height: ScreenUtil().setHeight(220),
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          imageUrl: _piclist[index]["image"],
                          placeholder: (context, url) =>
                              Image.asset("images/app.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("images/app.png"),
                        );
                      },
                      onTap: (int index) {
                        FocusScope.of(context).requestFocus(FocusNode()); // 缩回键盘
                        var _url = _piclist[index]["url"] as String;
                        if (_url.startsWith("?")) {
                          //调转 单品
                          // 跳转 搜索
                          var strs = _url.split("=");
                          if (strs.length > 0)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GoodView(gid: strs[1])));
                        } else {
                          // 跳转 搜索
                          var strs = _url.split("=");
                          if (strs.length > 0)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchResult(searchText: strs[1])));
                        }
                      },
                      itemCount: _piclist.length,
                      scrollDirection: Axis.horizontal,
                      loop: true,
                      duration: 300,
                      autoplay: true,
                      // pagination: SwiperPagination(),//原点
                    ),
                  ),
                )),
              ],
            )),
      ],
    );
  }
}
