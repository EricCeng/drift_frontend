import 'package:dio/dio.dart';
import 'package:drift_frontend/http/base_model.dart';
import 'package:oktoast/oktoast.dart';

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
          // errorCOde = -1001 代表登录失败，需要重新登录
          var rsp = BaseModel.fromJson(response.data);
          if (rsp.errorCode == 0) {
            if (rsp.data == null) {
              handler.next(Response(
                  requestOptions: response.requestOptions, data: true));
            } else {
              handler.next(Response(
                  requestOptions: response.requestOptions, data: rsp.data));
            }
          } else if (rsp.errorCode == -1001) {
            handler.reject(DioException(
                requestOptions: response.requestOptions, message: "未登录"));
            showToast("请先登录");
          } else if (rsp.errorCode == -1) {
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
    } else {
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}
