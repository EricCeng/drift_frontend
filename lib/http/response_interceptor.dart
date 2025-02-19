import 'package:dio/dio.dart';
import 'package:drift_frontend/http/base_model.dart';
import 'package:drift_frontend/route/routes.dart';
import 'package:oktoast/oktoast.dart';

import '../route/route_utils.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      // 判断是否为蒲公英得接口
      if (response.requestOptions.path.contains("/apiv2/app/check")) {
        handler.next(response);
      } else {
        try {
          // errorCode = 0 代表成功
          // errorCOde = 401 代表未登录
          // errorCode = 402 代表会话已过期，需要重新登录
          var rsp = BaseModel.fromJson(response.data);
          if (rsp.errorCode == 0) {
            if (rsp.data == null) {
              handler.next(Response(
                  requestOptions: response.requestOptions, data: true));
            } else {
              handler.next(Response(
                  requestOptions: response.requestOptions, data: rsp.data));
            }
          } else if (rsp.errorCode == 401) {
            handler.reject(DioException(
                requestOptions: response.requestOptions, message: "未登录"));
            showToast("请先登录");
            RouteUtils.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RoutePath.loginPage, (route) => false);
          } else if (rsp.errorCode == 402) {
            handler.reject(DioException(
                requestOptions: response.requestOptions, message: "会话已过期"));
            showToast("会话已过期，请重新登录");
            RouteUtils.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RoutePath.loginPage, (route) => false);
          } else {
            showToast(rsp.errorMsg ?? "");
            if (rsp.data == null) {
              handler.next(Response(
                  requestOptions: response.requestOptions, data: false));
            } else {
              handler.next(Response(
                  requestOptions: response.requestOptions, data: rsp.data));
            }
          }
        } catch (e) {
          handler.reject(DioException(
              requestOptions: response.requestOptions, message: "$e"));
        }
      }
    } else if (response.statusCode == 0) {
      showToast("网络连接断开，请检查网络设置");
    } else {
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}
