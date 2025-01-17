import 'package:dio/dio.dart';
import 'package:drift_frontend/http/cookie_interceptor.dart';
import 'package:drift_frontend/http/print_log_interceptor.dart';
import 'package:drift_frontend/http/response_interceptor.dart';

import 'http_method.dart';

class DioInstance {
  // 私有静态
  static DioInstance? _instance;

  // 私有构造
  DioInstance._();

  static DioInstance instance() {
    // ?? 后要加个 =，不然一直会初始化一个新的实例
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTime = const Duration(seconds: 30);

  void initDio(
      {required String baseUrl,
      String? httpMethod = HttpMethod.GET,
      Duration? connectTimeout,
      Duration? receiveTimeout,
      Duration? sendTimeout,
      ResponseType? responseType = ResponseType.json,
      String? contentType}) {
    _dio.options = BaseOptions(
        method: httpMethod,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? _defaultTime,
        receiveTimeout: receiveTimeout ?? _defaultTime,
        sendTimeout: sendTimeout ?? _defaultTime,
        responseType: responseType,
        contentType: contentType);
    // _dio.interceptors.add(CookieInterceptor());
    _dio.interceptors.add(PrintLogInterceptor());
    _dio.interceptors.add(ResponseInterceptor());
  }

  Future<Response> get(
      {required String path,
      Map<String, dynamic>? param,
      Options? options,
      CancelToken? cancelToken}) async {
    return _dio.get(path,
        queryParameters: param,
        options: options ??
            Options(
                method: HttpMethod.GET,
                receiveTimeout: _defaultTime,
                sendTimeout: _defaultTime),
        cancelToken: cancelToken);
  }

  Future<Response> post(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    return _dio.post(path,
        queryParameters: queryParameters,
        data: data,
        options: options ??
            Options(
                method: HttpMethod.POST,
                receiveTimeout: _defaultTime,
                sendTimeout: _defaultTime),
        cancelToken: cancelToken);
  }

  void changeBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
