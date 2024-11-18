import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift_frontend/constants.dart';
import 'package:drift_frontend/utils/sp_utils.dart';

class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    SpUtils.getStringList(Constants.SP_COOKIE_LIST).then((cookieList) {
      options.headers[HttpHeaders.setCookieHeader] = cookieList;
      handler.next(options);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path.contains("login")) {
      dynamic cookieHeaders = response.headers[HttpHeaders.setCookieHeader];
      List<String> cookieList = [];
      if (cookieHeaders is List) {
        for (String? cookie in cookieHeaders) {
          cookieList.add(cookie ?? "");
          print("CookieInterceptor cookie= ${cookie.toString()}");
        }
      }
      SpUtils.saveStringList(Constants.SP_COOKIE_LIST, cookieList);
    }
    super.onResponse(response, handler);
  }
}
