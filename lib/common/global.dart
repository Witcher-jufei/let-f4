import 'dart:convert';
import '../main.dart';
import '../models/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bidder_api.dart';
import 'net_cache.dart';
// import 'net_cache.dart';


class Global {
  static MyApp myApp;
  static SharedPreferences _prefs;
  static String token = "";
  static Profile profile = Profile();
    // 网络缓存对象
  static NetCache netCache = NetCache();

  static String msgNum; // 消息数量


  //初始化全局信息
  static Future init() async {
    myApp = new MyApp();
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        // profile = Profile.fromJson(jsonDecode(_profile));
        // print(profile.token);
      } catch (e) {
        print(e);
      }
    }

    var _token = _prefs.getString("token");
    if (_token != null) {
      try {
        token = _token;
        // print(token);
      } catch (e) {
        print(e);
      }
    }

    //初始化网络请求相关配置
    Api.init();
  }

  // 持久化Profile信息
  static saveProfile() =>
      // _prefs.setString("profile", jsonEncode(profile.toJson()));
      _prefs.setString("token", token);
}
