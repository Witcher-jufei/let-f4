import 'dart:collection';
import 'package:dio/dio.dart';
import 'global.dart';



class NetCache extends Interceptor {

  @override
  onRequest(RequestOptions options) async {
    print(options as String);
  }
  @override
  onError(DioError error) async {
    print(error);
    print('object');
    
  }
}
