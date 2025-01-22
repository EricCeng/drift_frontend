import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift_frontend/constants.dart';
import 'package:drift_frontend/utils/sp_utils.dart';

class AccessTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    SpUtils.getString(Constants.SP_ACCESS_TOKEN).then((accessToken) {
      options.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";
      handler.next(options);
    });
  }
}
