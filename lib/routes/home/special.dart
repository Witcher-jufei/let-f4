import 'package:Bidder/routes/search/searchresult.dart';

import '../../common/bidder_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//热门
class SpecialView extends StatefulWidget {
  @override
  _SpecialViewState createState() => _SpecialViewState();
}

class _SpecialViewState extends State<SpecialView> {
  List<dynamic> specialslist = new List<dynamic>();

  void _loadSpecials() async {
    // 发送 登录 请求
    var res = await Api.getInstance().special();
    var code = res["code"] as String;
    if (code == "200") {
      var data = res["data"] as List<dynamic>;
      if (data.length > 0) {
        setState(() {
          specialslist = data;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSpecials();
  }

  @override
  Widget build(BuildContext context) {
    print('build _SpecialViewState');
    return specialslist.length > 0
        ? Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(7)),
                        width: ScreenUtil().setWidth(185),
                        height: ScreenUtil().setHeight(123),
                        color: Color.fromRGBO(238, 238, 238, 1),
                        // color: Colors.red,
                        child: CachedNetworkImage(
                          imageUrl: specialslist[0]["image"],
                          placeholder: (context, url) =>
                              Image.asset("images/app40px.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("images/app40px.png"),
                        ),
                      ),
                      Container(
                        // color: Colors.blue,
                        height: double.infinity,
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(11)),
                        child: Text(specialslist[0]["name"],
                            style: TextStyle(fontSize: 14.0)),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // 缩回键盘
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchResult(
                              searchText: specialslist[0]["name"])));
                },
              ),
              Container(
                // color: Colors.red,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Container(
                            child: CachedNetworkImage(
                              fit: BoxFit.fitHeight,
                              imageUrl: specialslist[1]["image"],
                              placeholder: (context, url) =>
                                  Image.asset("images/app40px.png"),
                              errorWidget: (context, url, error) =>
                                  Image.asset("images/app40px.png"),
                            ),
                            width: ScreenUtil().setWidth(153),
                            height: ScreenUtil().setHeight(58),
                            color: Color.fromRGBO(238, 238, 238, 1),
                            // color: Colors.red,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(11)),
                            child: Text(specialslist[1]["name"],
                                style: TextStyle(fontSize: 14.0)),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult(
                                    searchText: specialslist[1]["name"])));
                      },
                    ),
                    GestureDetector(
                      child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Container(
                          child: CachedNetworkImage(
                            fit: BoxFit.fitHeight,
                            imageUrl: specialslist[2]["image"],
                            placeholder: (context, url) =>
                                Image.asset("images/app40px.png"),
                            errorWidget: (context, url, error) =>
                                Image.asset("images/app40px.png"),
                          ),
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(7)),
                          width: ScreenUtil().setWidth(153),
                          height: ScreenUtil().setHeight(58),
                          color: Color.fromRGBO(238, 238, 238, 1),
                          // color: Colors.blue,
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(11)),
                          child: Text(specialslist[2]["name"],
                              style: TextStyle(fontSize: 14.0)),
                        )
                      ],
                    ),
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult(
                                    searchText: specialslist[2]["name"])));
                      },
                    ),
                    
                  ],
                ),
              ),
            ],
          )
        : Row();
  }
}
