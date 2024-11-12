import 'dart:developer';

import 'package:dio/dio.dart';

class PrintLogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("<----------Request----------");
    options.headers.forEach((key, value) {
      log("header: key=$key  value=${value.toString()}");
    });
    log("path: ${options.uri}");
    log("method: ${options.method}");
    log("data: ${options.data}");
    log("queryParameters: ${options.queryParameters.toString()}");
    log("----------Request---------->\n");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    log("<----------Response----------");
    log("header: ${response.headers.toString()}");
    log("path: ${response.realUri}");
    log("statusCode: ${response.statusCode}");
    log("statusMessage: ${response.statusMessage}");
    log("extra: ${response.extra.toString()}");
    log("data: ${response.data}");
    log("----------Response---------->\n");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("<----------Error----------");
    log("error: ${err.toString()}");
    log("----------Error---------->\n");
    super.onError(err, handler);
  }
}
