import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'global.dart';

class Api {
  static Api _instance;
  static Api getInstance() {
    if (_instance == null) {
      _instance = Api();
    }
    return _instance;
  }

  Dio dio = new Dio(BaseOptions(
    baseUrl: 'http://bidderdev.artcare.com/',
    headers: {
      // HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
      //     "application/vnd.github.symmetra-preview+json",
    },
  ));

  static void init() {
    // 添加缓存插件
    // getInstance().dio.interceptors.add(Global.netCache);

    // 设置用户token（可能为null，代表未登录）
    // dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
  }

  static Future<Map<String, dynamic>> get(
      String path, Map<String, dynamic> _map) async {
    // print(Global.token);
    Map<String, dynamic> map = {'token': Global.token};
    map.addAll(_map);
    // print(map);
    var response = await getInstance().dio.get(path, queryParameters: map);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = convert.jsonDecode(response.data);
      return data;
    }
    throw Exception("server error");
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> _map) async {
    // print(Global.token);
    Map<String, dynamic> map = {'token': Global.token};
    map.addAll(_map);
    print(map);

    var response = await getInstance().dio.post(path, queryParameters: map);
    if (response.statusCode == 200) {
      // print(response.data);
      Map<String, dynamic> data = convert.jsonDecode(response.data);
      return data;
    }
    throw Exception("server error");
  }

  // 验证码接口
  Future<Map<String, dynamic>> verify(String tel) async {
    var path = '/verify';
    var map = {'tel': tel};
    return await Api.get(path, map);
  }

  // 登录接口
  Future<Map<String, dynamic>> login(String tel, String verify) async {
    var path = '/login';
    var map = {'tel': tel, 'verify': verify};
    return await Api.get(path, map);
  }

  //消息个数
  Future<Map<String, dynamic>> getMsgsNumByUid() async {
    var path = '/getMsgsNumByUid';
    return await Api.get(path, {});
  }

  //消息列表
  Future<Map<String, dynamic>> getMsgsByUid(Map<String, dynamic> _map) async {
    var path = '/getMsgsByUid';
    return await Api.get(path, _map);
  }

  // 轮播图
  Future<Map<String, dynamic>> rotaryMap() async {
    var path = '/rotaryMap';
    return await Api.get(path, {});
  }

  // 分类
  Future<Map<String, dynamic>> goodsType() async {
    var path = '/goodsType';
    return await Api.get(path, {});
  }

  // 专题
  Future<Map<String, dynamic>> special() async {
    var path = '/special';
    return await Api.get(path, {});
  }

  //首页选购
  Future<Map<String, dynamic>> chooseGoodsList(int page) async {
    var path = '/chooseGoodsList';
    return await Api.get(path, {"page": page});
  }

  //搜索筛选
  Future<Map<String, dynamic>> chooseGoodsSearch(
      Map<String, dynamic> _map) async {
    var path = '/chooseGoodsSearch';
    return await Api.get(path, _map);
  }

  //商品详情
  Future<Map<String, dynamic>> chooseGoodsDetails(String id) async {
    var path = '/chooseGoodsDetails';
    return await Api.get(path, {"id": id});
  }

  // 收藏取藏
  Future<Map<String, dynamic>> addGoodsCollection(String id) async {
    var path = '/addChooseGoodsCollection';
    return await Api.get(path, {"id": id});
  }

  // 收藏列表
  Future<Map<String, dynamic>> collectionGoods(int page) async {
    var path = '/chooseGoodsCollection';
    return await Api.get(path, {"page": page});
  }

  // 新闻列表
  Future<Map<String, dynamic>> getNews(int page) async {
    var path = '/information';
    return await Api.get(path, {"page": page});
  }

  // 新增收货地址
  Future<Map<String, dynamic>> addAddress(String _name, String _tel,
      String _area, String _addr, bool _default) async {
    var path = '/addAddress';
    return await Api.post(path, {
      'name': _name,
      'tel': _tel,
      'area': _area,
      'address': _addr,
      'default': _default?1:0
    });
  }

    // 新增收货地址
  Future<Map<String, dynamic>> getDefultAddr() async {
    var path = '/getDefultAddr';
    return await Api.get(path, {});
  }

  // 修改收货地址
  Future<Map<String, dynamic>> updateAddress(String _id, String _name, String _tel,
      String _area, String _addr, bool _default) async {
    var path = '/addressEdit';
    return await Api.post(path, {
      'id':_id,
      'name': _name,
      'tel': _tel,
      'area': _area,
      'address': _addr,
      'default': _default?1:0
    });
  }

  //设置为默认
  Future<Map<String, dynamic>> addrSetDefault(String _id) async {
    var path = '/addrSetDefault';
    return await Api.get(path, {'id': _id});
  }

  //删除地址
  Future<Map<String, dynamic>> delAddress(String _id) async {
    var path = '/deleteAdress';
    return await Api.get(path, {'id': _id});
  }

  // 地址列表
  Future<Map<String, dynamic>> addressList() async {
    var path = '/addressList';
    return await Api.get(path, {});
  }

  // 创建订单
  /*
  $addressid = $r->addressid;
		$goodsid =$r->goodsid;
		$goods_num = $r->goods_num;
		$remarks = $r->remarks;
  */
  Future<Map<String, dynamic>> createChooseOrder(String _addrid, String _gid, int _gnum, String _remarks) async {
    var path = '/createChooseOrder';
    return await Api.post(path, {'addressid':_addrid, 'goodsid':_gid, 'goods_num':_gnum, 'remarks':_remarks});
  }

  // 支付订单 -- 支付宝
  /**
   * $order_id = $r->order_id; 订单ID
        $addrid = $r->addrid; 收货地址ID
        $remarks = $r->remarks; 备注
   */
  Future<Map<String, dynamic>> aliPay(String _orderid, String _addrid, String _remarks) async {
    var path = '/aliAppPay';
    // return await Api.post(path, {'order_id':_orderid, 'addrid':_addrid, 'remarks':_remarks});


    // https://bidder.artcare.com/aliAppPay?token=MwTagn1gMxTiEn1dOaDhIaxoMrDeMn0Mjk4ODk4NTIO0O0O&order_id=160&addrid=69&remarks=test
    var _map = {'order_id':168, 'addrid':69, 'remarks':'test'};
    // print(Global.token);
    Map<String, dynamic> map = {'token': 'MwTagn1gMxTiEn1dOaDhIaxoMrDeMn0Mjk4ODk4NTIO0O0O'};
    map.addAll(_map);
    // print(map);
    
    Dio _dio = new Dio(BaseOptions(
      baseUrl: 'http://bidder.artcare.com/',
      headers: {
        // HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
        //     "application/vnd.github.symmetra-preview+json",
      },
    ));
    
    var response = await  _dio.get(path, queryParameters: map);
    if (response.statusCode == 200) {
      // print(response.data);
      Map<String, dynamic> data = convert.jsonDecode(response.data);
      return data;
    }
    throw Exception("server error");
  }  

  // 支付订单 -- 微信
  /**
   * $order_id = $r->order_id; 订单ID
        $addrid = $r->addrid; 收货地址ID
        $remarks = $r->remarks; 备注
   */
  Future<Map<String, dynamic>> wechatPay(String _orderid, String _addrid, String _remarks) async {
    var path = '/wechatAppPay';
    // return await Api.post(path, {'order_id':_orderid, 'addrid':_addrid, 'remarks':_remarks});


    // https://bidder.artcare.com/aliAppPay?token=MwTagn1gMxTiEn1dOaDhIaxoMrDeMn0Mjk4ODk4NTIO0O0O&order_id=160&addrid=69&remarks=test
    var _map = {'order_id':168, 'addrid':69, 'remarks':'test'};
    // print(Global.token);
    Map<String, dynamic> map = {'token': 'MwTagn1gMxTiEn1dOaDhIaxoMrDeMn0Mjk4ODk4NTIO0O0O'};
    map.addAll(_map);
    // print(map);
    
    Dio _dio = new Dio(BaseOptions(
      baseUrl: 'http://bidder.artcare.com/',
      headers: {
        // HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
        //     "application/vnd.github.symmetra-preview+json",
      },
    ));
    
    var response = await  _dio.get(path, queryParameters: map);
    if (response.statusCode == 200) {
      // print(response.data);
      Map<String, dynamic> data = convert.jsonDecode(response.data);
      return data;
    }
    throw Exception("server error");
  }

  // 订单详情 
  /*
  $addressid = $r->addressid;
		$goodsid =$r->goodsid;
		$goods_num = $r->goods_num;
		$remarks = $r->remarks;
  */
  Future<Map<String, dynamic>> chooseOrderDetail(String orderid) async {
    var path = '/chooseOrderDetail';
    return await Api.get(path, {'order_id':orderid});
  }

  //订单列表
  // status 0待支付1已支付待发货2已发货待收货3完成4全部
  Future<Map<String, dynamic>> chooseOrderList(int page, int status) async {
    var path = '/chooseOrderList';
    return await Api.get(path, {"page": page, 'status':status});
  }

  // 确认订单 确认收货
  Future<Map<String, dynamic>> confirmOrder(String orderid) async {
    var path = '/confirmOrder';
    return await Api.get(path, {"order_id": orderid});
  }

  // 用户信息 userinfo
  Future<Map<String, dynamic>> userinfo() async {
    var path = '/userinfo';
    return await Api.get(path, {});
  }

  // 用户信息 userinfo
  Future<Map<String, dynamic>> editUserName(String _name) async {
    var path = '/editName';
    return await Api.post(path, {'name': _name});
  }
  
  // 上传头像
  Future<Map<String, dynamic>> uploadHeader(String filepath) async {
    var path = '/uploadHeader';
    FormData formData = new FormData.fromMap({
      "token": Global.token,
      "file": await MultipartFile.fromFile(filepath),
    });
    var response = await getInstance().dio.post(path, data: formData);
    if (response.statusCode == 200) {
      // print(response.data);
      Map<String, dynamic> data = convert.jsonDecode(response.data);
      return data;
    }
    throw Exception("server error");
  }
  
}
