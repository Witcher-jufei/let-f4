import 'package:Bidder/common/bidder_api.dart';
import 'package:Bidder/routes/details/goodview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 简单列表项
class GoodItem extends StatefulWidget {
  final dynamic item;
  const GoodItem({Key key, this.item}) : super(key: key);

  @override
  _GoodItemState createState() => _GoodItemState();
}

class _GoodItemState extends State<GoodItem> {
  void _addCollection() async {
    // 发送 收藏 请求
    var res = await Api.getInstance().addGoodsCollection(widget.item['id']);
    var code = res["code"] as String;
    if (code == "200") {
      setState(() {
        widget.item["collection"] = '1';
      });
    } else {
      setState(() {
        widget.item["collection"] = '0';
      });
    }
    Fluttertoast.showToast(msg: res["msg"]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        // color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    // color: Color(0xFFEEEEEE),
                    // color:Colors.red,
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      width: ScreenUtil().setHeight(165),
                      height: ScreenUtil().setHeight(165),
                      imageUrl: widget.item["coverimage"],
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) =>
                          Image.asset("images/app40px.png"),
                      errorWidget: (context, url, error) =>
                          Image.asset("images/app40px.png"),
                    )),
                Container(
                    color: Colors.blue,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(13)),
                    child: widget.item["bestSellers"] == "1"
                        ? Image.asset("images/yus.png")
                        : null)
              ],
            ),
            Container(
              // color: Colors.blue,
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
              child: Text(widget.item["name"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.0)),
            ),
            Container(
              // color: Colors.black,
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(2)),
              // height: ScreenUtil().setHeight(66),
              child: Row(
                children: <Widget>[
                  Container(
                    // color: Colors.red,
                    width: ScreenUtil().setWidth(140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:
                              Text(widget.item["present_price"], style: TextStyle(fontSize: 12.0)),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                          height: ScreenUtil().setHeight(11),
                          color: Color.fromRGBO(211, 243, 255, 1),
                          child: Text(
                            widget.item["business"],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(7),
                              color: Color.fromRGBO(18, 175, 234, 1),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                          width: ScreenUtil().setWidth(18),
                          height: ScreenUtil().setHeight(18),
                          child: widget.item["collection"] == "0"
                              ? Image.asset("images/collection/collection.png")
                              : Image.asset(
                                  "images/collection/collection-s.png")),
                      onTap: () {
                         _addCollection();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // print("aaaaa");
        FocusScope.of(context).requestFocus(FocusNode()); // 缩回键盘
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GoodView(gid: widget.item["id"] as String)));
      },
    );
  }
}
