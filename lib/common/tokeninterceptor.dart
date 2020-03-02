
import 'package:dio/dio.dart';

import 'bidder_api.dart';

class TokenInterceptor extends Interceptor {
   @override
  onError(DioError error) async {
    print('AAA');
    super.onError(error);
  }
}