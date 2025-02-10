import 'package:drift_frontend/http/dio_instance.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:drift_frontend/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  // DioInstance.instance().initDio(baseUrl: "http://127.0.0.1:16780/drift");
  DioInstance.instance().initDio(baseUrl: "http://10.0.2.2:16780/drift");
  // 启用手势调试日志
  // debugPrintGestureArenaDiagnostics = true;
  runApp(const MyApp());
}

// 设计尺寸
Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  // 逻辑短边
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  // 逻辑长边
  final logicalLongestSide =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  // 缩放比例 designSize 越小，元素越大
  const scaleFactor = 0.95;
  // 缩放后的逻辑短边和长边
  return Size(
      logicalShortestSide * scaleFactor, logicalLongestSide * scaleFactor);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Flutter Demo",
          theme: ThemeData(
              //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              scaffoldBackgroundColor: Colors.white,
              canvasColor: Colors.white,
              useMaterial3: true),
          navigatorKey: RouteUtils.navigatorKey,
          onGenerateRoute: Routes.generateRoute,
          initialRoute: RoutePath.splash,
          // home: const HomePage(),
        );
      },
    ));
  }
}
